/*
version 7.1 - 2018.12.12 - Cause�Ĵ�����IPλ��ȫ�հ�HWInt�ⲿ�źŵ����ݡ�
version 8.0 - 2018.12.29 - �޸�Cause�Ĵ�����HWIntֵ��ֵ��ʽ���������ж��쳣��HWInt������ʵʱ�仯��
*/
`timescale 1ns / 1ps
module CP0(Clock,Reset,WE,ExlSet,ExlClr,							
			  RA,WA,WD,PC,ExcCode,BD,
			  HWInt,
			  IntReq,EPC,RD);
		
		input Clock;
		input Reset;
		input WE;							// �����źţ�ָ���E��MCtrl
		input ExlSet;						// �����źţ���ָ���ExcCtrl --- ���ź���ExcCtrl����Cp0���ж��쳣�����ź�
		input ExlClr;						// �����źţ�ָ���E����D����ɣ�MCtrl
		input [4:0] RA;					// ����ͨ·����ȡ��ַ��EM_IR
		input [4:0] WA;					// ����ͨ·��д���ַ��EM_IR
		input [31:0] WD;					// ����ͨ·��д���ַ��EM_IR
		input [31:0] PC;					// ����ͨ·��PCMUX������ݣ�����EPC��
		input [6:2] ExcCode;				// ����ͨ·��ExcMux������ݣ�����Cause��
		input BD;							// ����ͨ·��M_BD������ݣ�����Cause��
		input [5:0] HWInt;				// �ⲿ�źţ��豸�ж�����
		output IntReq;						// ����ͨ·���ж������ź� -> ExcCtrl
		output [31:0] EPC;				// ����ͨ·��EPC�Ĵ���ֵ -> NPC
		output [31:0] RD;					// ����ͨ·����ȡ�Ĵ���ֵ -> MUX @ E-level
		
		wire [31:0] empty;
		// SR
		wire [31:0] sr;
		reg [15:10] im;
		reg exl;
		reg ie;
		// Cause
		wire [31:0] cause;
		reg bd;
		reg [15:10] ip;
		reg [6:2] exccode;
		// EPC
		reg [31:0] epc;
		// PRID
		reg [31:0] prid;
		
		// combine sr and cause
		assign empty = 32'h00000000;
		assign sr = {empty[31:16],im[15:10],empty[9:2],exl,ie};
		assign cause = {bd,empty[30:16],ip[15:10],empty[9:7],exccode[6:2],empty[1:0]};
		
		// output 1: IntReq
		assign IntReq = (|(im[15:10] & HWInt[5:0])) & (~exl) & ie;
		
		// output 2: EPC
		assign EPC = epc;
		
		// output 3: RD
		assign RD = (RA==12)?sr:
						(RA==13)?cause:
						(RA==14)?epc:
						(RA==15)?prid:
						32'h00000000;
		
		// ���Ĳ��֣�ʱ���߼����²���
		initial begin
			im = 0;
			exl = 0;
			ie = 0;
			
			bd = 0;
			ip = 0;
			exccode = 0;
			
			epc = 0;
			
			prid = 32'h19990805;
		end
		
		always @(posedge Clock)begin
			// ip <= HWInt;														// debug : IP copy the HWInt
			if(Reset)begin
				im <= 0;
				exl <= 0;
				ie <= 0;
				
				bd <= 0;
				ip <= 0;
				exccode <= 0;
				
				epc <= 0;
			end
			else begin
				// situation: �ж��쳣���������
				if(ExlSet)begin
					exl <= 1;
					bd <= BD;
					ip <= HWInt;
					exccode <= ExcCode;
					epc <= PC;
				end
				// situation: �ж��쳣�������-eret
				else if(ExlClr)begin
					exl <= 0;																		// ? �� ��cause�Ĵ����е�ֵ�Ƿ���Ҫ�仯
				end
				// situation: cp0д��
				else if(WE)begin
					// SR
					if(WA==12)begin
						im[15:10] <= WD[15:10];
						exl <= WD[1];
						ie <= WD[0];
					end
					// Cause
					else if(WA==13)begin
						bd <= WD[31];
						ip[15:10] <= WD[15:10];
						exccode[6:2] <= WD[6:2];
					end
					else if(WA==14)	{epc}<=WD;
					else if(WA==15)	{prid}<=WD;
				end
			end
		end

endmodule
