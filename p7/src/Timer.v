/*
version 7.1 - 2018.12.12 ������CNT->INT���������ӵ��ڱ�ΪС�ڵ��ڡ�
version 7.5 - 2018.12.19 �Ż��˶�CTRL�Ĵ���λ���ĵ��ã�������wire�ͱ�������ֱ�۶�ȡ��������IRQ����߼�����reg���wire�������м��ź�irq����¼�ڲ��ж�����
version 7.5 - 2018.12.19 ������дCTRL���߼���������д��32~4λ��
*/
`timescale 1ns / 1ps
`define IDLE 0
`define LOAD 1
`define CNT 2
`define INT 3

`define CTRL 0
`define PRESET 1
`define COUNT 2

module Timer(Clock,Reset,Addr,WE,WD,RD,IRQ);
	input Clock;
	input Reset;
	input [3:2] Addr;
	input WE;
	input [31:0] WD;
	output [31:0] RD;
	output IRQ;
	
	reg [31:0]regs[2:0];						// ����timer�е������ڲ��Ĵ���
	reg [1:0]state;							// ����״̬��¼��
	reg irq;									// IRQ�м��ź�
	wire enable,im;							// ��CTRL �Ĵ�����ȡ������Чλ��ֻ����
	wire [2:1] type;
	
	initial begin
		regs[`CTRL] = 0;
		regs[`PRESET] = 0;
		regs[`COUNT] = 0;
		state = `IDLE;
		irq = 0;
	end
	
	// RD
	assign RD = (Addr>=0&&Addr<=2)?regs[Addr]:32'hZZZZZZZZ;
	// IRQ
	assign IRQ = irq & im;
	
	// ��ȡCTRL�Ĵ����е���Чλ������۲�����
	assign enable = regs[`CTRL][0];
	assign type = regs[`CTRL][2:1];
	assign im  =regs[`CTRL][3];
	
	// ���ȼ���reset > WE > �ڲ�״̬ת��
	always @(posedge Clock)begin
		if(Reset)begin											// priority 1
			regs[`CTRL] <= 0;
			regs[`PRESET] <= 0;
			regs[`COUNT] <= 0;
			state <= `IDLE;
			irq <= 0;
		end
		else begin
			if(WE)begin											// priority 2
				if(Addr==0)
					regs[0][3:0] <= WD[3:0];
				else if(Addr==1)
					regs[1] <= WD;
			end
			else begin											// priority 3
				case(state)
					`IDLE:begin									// �˽׶�ģʽ0��1ӵ��һ�µ���Ϊ���ϲ�
						if(enable==1)begin
							irq <= 0;
							state <= `LOAD;
						end
					end
					`LOAD:begin									// �˽׶�ģʽ0��1�ж�һ�£��ϲ�
						regs[`COUNT] <= regs[`PRESET];
						state <= `CNT;
					end
					`CNT:begin
						if(enable==0)state <= `IDLE;// ��ͣ��������������
						else begin								// ��ģʽ����
							// mode 0
							if(type==0)begin
								regs[`COUNT] <= regs[`COUNT] - 1;
								if(regs[`COUNT]<=1) begin		// count=1��������ʱ�ᵽ��0,��˴���ת�Ƶ�INTģʽ
									regs[`CTRL][0] <= 0;			// ģʽ0�У�����0��ʹ�ܶϿ�
									irq <= 1;
									state <= `INT;
								end
							end
							// mode 1
							else if(type==1)begin
								regs[`COUNT] <= regs[`COUNT] - 1;
								if(regs[`COUNT]<=1) begin		// count=1��������ʱ�ᵽ��0,��˴���ת�Ƶ�INTģʽ
									irq <= 1;
									state <= `INT;
								end
							end
							else state <= `IDLE;
						end
					end
					`INT:begin
						//mode 0
						if(type==0)begin
							state <= `IDLE;
						end
						else if(type==1)begin											// question !!!: ���׼״̬ת��ͼ��һ�£�ֻ���������ܱ�֤��������Ϊ0����������pre�е�ֵ����
							irq <= 0;
							state <= `IDLE;
						end
						else state <= `IDLE;
					end
				endcase
			end
		end
	end

endmodule
