/*
version 7.0 - 2018.12.10 - 增加了Enable端口，激活后不会启动运算。
version 7.5 - 2018.12.18 - 支持除0不变功能，同步mars情况
*/
`timescale 1ns / 1ps
`include "head.v"
module XALU(Clock,Reset,Start,Enable,XALUOp,Busy,RD1,RD2,HI,LO);
	input Clock;
	input Reset;
	input [1:0] Start;							// 1-启动乘除法,2-启动hi和lo赋值，0-不启动
	input Enable;
	input [`xaluop_size-1:0] XALUOp;			// xalu操作类型模块
	input [31:0] RD1;
	input [31:0] RD2;
	output reg [31:0] HI;
	output reg [31:0] LO;
	output reg Busy;
	
	integer count;													// 运行节拍器
	reg [63:0] mult;												// 运行结果缓存器
	reg [63:0] multu;
	reg [63:0] div;
	reg [63:0] divu;												
	reg [`xaluop_size-1:0] xaluop_saver;					// xalu运行类型保存器（乘除法使用）
	
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
	
	// XALU中间运算者，根据Busy信号计时和复位.
	always @(posedge Clock)begin
		if(Reset)begin
			count <= 1;
		end
		else begin
			if(Busy)
				count <= count + 1;
			else 
				count <= 1;															// count代表执行此指令累积时间，由于写操作需要1个周期，因此初始值设为1.
			end
	end
	
	// XALU运算的启动者和终结者，中间运算（计时）由其他模块进行。
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
			// 终结者
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
			// 启动者
			else if(Start>0&&Enable)begin
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
						if(RD2!=0)
							div <= {$signed(RD1)%$signed(RD2),$signed(RD1)/$signed(RD2)};										// div-begin
						else 
							div <= {HI,LO};
						xaluop_saver <= XALUOp;
						Busy <= 1;
					end
					3:begin
						if(RD2!=0)
							divu <= {RD1%RD2,RD1/RD2};						// divu-begin
						else 
							divu <= {HI,LO};
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
