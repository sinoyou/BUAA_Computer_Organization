/*
version 7.1 - 2018.12.12 - Cause寄存器的IP位完全照搬HWInt外部信号的内容。
*/
`timescale 1ns / 1ps
module CP0(Clock,Reset,WE,ExlSet,ExlClr,							
			  RA,WA,WD,PC,ExcCode,BD,
			  HWInt,
			  IntReq,EPC,RD);
		
		input Clock;
		input Reset;
		input WE;							// 控制信号，指令级，E级MCtrl
		input ExlSet;						// 控制信号，非指令级，ExcCtrl --- 此信号是ExcCtrl发向Cp0的中断异常启动信号
		input ExlClr;						// 控制信号，指令级，E级（D级亦可）MCtrl
		input [4:0] RA;					// 数据通路，读取地址，EM_IR
		input [4:0] WA;					// 数据通路，写入地址，EM_IR
		input [31:0] WD;					// 数据通路，写入地址，EM_IR
		input [31:0] PC;					// 数据通路，PCMUX输出内容，存入EPC中
		input [6:2] ExcCode;				// 数据通路，ExcMux输出内容，存入Cause中
		input BD;							// 数据通路，M_BD输出内容，存入Cause中
		input [5:0] HWInt;				// 外部信号，设备中断请求
		output IntReq;						// 数据通路，中断请求信号 -> ExcCtrl
		output [31:0] EPC;				// 数据通路，EPC寄存器值 -> NPC
		output [31:0] RD;					// 数据通路，读取寄存器值 -> MUX @ E-level
		
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
		
		// 核心部分：时序逻辑更新部分
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
			ip <= HWInt;														// debug : IP copy the HWInt
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
				// situation: 中断异常处理的启动
				if(ExlSet)begin
					exl <= 1;
					bd <= BD;
					// ip <= HWInt;
					exccode <= ExcCode;
					epc <= PC;
				end
				// situation: 中断异常处理结束-eret
				else if(ExlClr)begin
					exl <= 0;																		// ? ： 对cause寄存器中的值是否需要变化
				end
				// situation: cp0写入
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
