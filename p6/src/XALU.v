`timescale 1ns / 1ps
`include "head.v"
module XALU(Clock,Reset,Start,XALUOp,Busy,RD1,RD2,HI,LO);
	input Clock;
	input Reset;
	input [1:0] Start;							// 1-�����˳���,2-����hi��lo��ֵ��0-������
	input [`xaluop_size-1:0] XALUOp;			// xalu��������ģ��
	input [31:0] RD1;
	input [31:0] RD2;
	output reg [31:0] HI;
	output reg [31:0] LO;
	output reg Busy;
	
	integer count;													// ���н�����
	reg [63:0] mult;												// ���н��������
	reg [63:0] multu;
	reg [63:0] div;
	reg [63:0] divu;												
	reg [`xaluop_size-1:0] xaluop_saver;					// xalu�������ͱ��������˳���ʹ�ã�
	
	initial begin
			HI = 0;
			LO = 0;
			Busy = 0;
			count = 0;
			mult = 0;
			multu = 0;
			div = 0;
			divu = 0;
			xaluop_saver = 0;
	end
	
	// XALU�м������ߣ�����Busy�źż�ʱ�͸�λ.
	always @(posedge Clock)begin
		if(Reset)begin
			count <= 1;
		end
		else begin
			if(Busy)
				count <= count + 1;
			else 
				count <= 1;															// count����ִ�д�ָ���ۻ�ʱ�䣬����д������Ҫ1�����ڣ���˳�ʼֵ��Ϊ1.
			end
	end
	
	// XALU����������ߺ��ս��ߣ��м����㣨��ʱ��������ģ����С�
	always @(posedge Clock)begin
		if(Reset)begin
			HI <= 0;
			LO <= 0;
			Busy <= 0;
			mult <= 0;
			multu <= 0;
			div <= 0;
			divu <= 0;
			xaluop_saver <= 0;
		end
		else begin
			// �ս���
			if(Busy)begin
				if(xaluop_saver==0&&count==5)begin						// mult
					{HI,LO} <= mult;
					Busy <= 0;
				end
				else if(xaluop_saver==1&&count==5)begin				// multu
					{HI,LO} <= multu;
					Busy <= 0;
				end
				else if(xaluop_saver==2&&count==10)begin				// div
					{HI,LO} <= div;
					Busy <= 0;
				end
				else if(xaluop_saver==3&&count==10)begin				// divu
					{HI,LO} <= divu;
					Busy <= 0;
				end
			end			
			// ������
			else if(Start>0)begin
				case(XALUOp)
					0:	begin																												// mult-begin
						// mult <= {RD1 * RD2}[63:0];
						mult <= {{32{RD1[31]}},RD1} * {{{32{RD2[31]}},RD2}};
						xaluop_saver <= XALUOp;
						Busy <= 1;
					end
					1:	begin
						// multu <= {{1'b0,RD1}*{1'b0,RD2}}[63:0];																	// multu-begin
						multu <= {32'b0,RD1}*{32'b0,RD2};
						xaluop_saver <= XALUOp;
						Busy <= 1;
					end
					2:begin
						div <= {$signed(RD1)%$signed(RD2),$signed(RD1)/$signed(RD2)};																// div-begin
						xaluop_saver <= XALUOp;
						Busy <= 1;
					end
					3:begin
						divu <= {RD1%RD2,RD1/RD2};						// divu-begin
						xaluop_saver <= XALUOp;
						Busy <= 1;
					end
					4:																										// move to hi register
						HI <= RD1;
					5:																										// move to lo register
						LO <= RD1;
				endcase
			end
		end
	end
	

endmodule
