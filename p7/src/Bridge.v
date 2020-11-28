/*
version 7.5 - 2018.12.18 - 修复了HWInt两个硬件设备相反的问题。
*/
/*	Timer t1(.Clock(Clock),.Reset(Reset),
				.Addr(PrAddr[3:2]),
				.WE(PrWe && PrAddr[31:4]==28'h00007f0 && PrBE==4'b1111),
				.WD(PrWd),
				.RD(rd_timer1),
				.IRQ(irq_timer1));
*/
`timescale 1ns / 1ps
`include "head.v"
module Bridge(CPUI_PrWe,CPUI_PrBE,CPUI_PrAddr,CPUI_PrWd,
				  CPUO_PrRd,CPUO_HWInt,
				  TIMER1I_Rd,TIMER1I_IRQ,
				  TIMER1O_Addr,TIMER1O_We,TIMER1O_Wd,
				  TIMER2I_Rd,TIMER2I_IRQ,
				  TIMER2O_Addr,TIMER2O_We,TIMER2O_Wd);
	
	// 与CPU交互的数据流
	input CPUI_PrWe;
	input [3:0] CPUI_PrBE;
	input [31:0] CPUI_PrAddr;
	input [31:0] CPUI_PrWd;
	output [31:0] CPUO_PrRd;
	output [7:2] CPUO_HWInt;
	// 与Timer1交互的数据流
	input [31:0] TIMER1I_Rd;
	input TIMER1I_IRQ;
	output [3:2] TIMER1O_Addr;
	output TIMER1O_We;
	output [31:0] TIMER1O_Wd;
	// 与Timer2交互的数据流
	input [31:0] TIMER2I_Rd;
	input TIMER2I_IRQ;
	output [3:2] TIMER2O_Addr;
	output TIMER2O_We;
	output [31:0] TIMER2O_Wd;
	
	// for cpu
	assign CPUO_HWInt[7:2] = {1'b0, 1'b0, 1'b0, 1'b0, TIMER2I_IRQ, TIMER1I_IRQ};
	assign CPUO_PrRd = (CPUI_PrAddr>=32'h00007f00 && CPUI_PrAddr<=32'h00007f0b)? TIMER1I_Rd:
							 (CPUI_PrAddr>=32'h00007f10 && CPUI_PrAddr<=32'h00007f1b)? TIMER2I_Rd:
							 32'hZZZZZZZZ;
	
	// for timer1
	assign TIMER1O_Addr = CPUI_PrAddr[3:2];
	assign TIMER1O_We = CPUI_PrAddr[31:4]==28'h00007f0 && CPUI_PrBE==4'b1111 && CPUI_PrWe;
	assign TIMER1O_Wd = CPUI_PrWd;
	
	// for timer2
	assign TIMER2O_Addr = CPUI_PrAddr[3:2];
	assign TIMER2O_We = CPUI_PrAddr[31:4]==28'h00007f1 && CPUI_PrBE==4'b1111 && CPUI_PrWe;
	assign TIMER2O_Wd = CPUI_PrWd;	

endmodule
/*module Bridge(Clock,Reset,PrWe,PrBE,PrAddr,PrWd,PrRd,HWInt);
	input Clock;
	input Reset;
	input PrWe;
	input [3:0] PrBE;
	input [31:0] PrAddr;
	input [31:0] PrWd;
	output [31:0] PrRd;
	output [7:2] HWInt;
	
	// 定义两个timer设备的输出信号
	wire [31:0] rd_timer1;
	wire [31:0] rd_timer2;
	wire irq_timer1;
	wire irq_timer2;
	
	Timer t1(.Clock(Clock),.Reset(Reset),
				.Addr(PrAddr[3:2]),
				.WE(PrWe && PrAddr[31:4]==28'h00007f0 && PrBE==4'b1111),
				.WD(PrWd),
				.RD(rd_timer1),
				.IRQ(irq_timer1));
	
	Timer t2(.Clock(Clock),.Reset(Reset),
				.Addr(PrAddr[3:2]),
				.WE(PrWe && PrAddr[31:4]==28'h00007f1 && PrBE==4'b1111),
				.WD(PrWd),
				.RD(rd_timer2),
				.IRQ(irq_timer2));
	
	assign HWInt[7:2] = {1'b0, 1'b0, 1'b0, 1'b0, irq_timer2, irq_timer1};
	assign PrRd = (PrAddr>=32'h00007f00 && PrAddr<=32'h00007f0b)? rd_timer1 : 
					  (PrAddr>=32'h00007f10 && PrAddr<=32'h00007f1b)? rd_timer2 : 
					  32'hZZZZZZZZ;

endmodule*/
