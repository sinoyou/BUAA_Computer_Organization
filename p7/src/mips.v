/*
version 7.6 2018.12.19 上移了timer1和timer2至顶层模块，修改了bridge连接，原本连线留有备份
*/
`timescale 1ns / 1ps
// `include "Control.v"
// `include "datapath.v"
`include "head.v"

module mips(clk,reset);
		input clk;
		input reset;
		
		// output of cpu
		wire prwe;						// 写使能信号
		wire [3:0] byteenable;		// 字选信号
		wire [31:0] praddr;			// 地址
		wire [31:0] prwd;				// 写数据
		
		// output of timer1
		wire [31:0] rd_timer1;		// timer1读取数据
		wire irq_timer1;				// timer1中断请求
		
		// output of timer2
		wire [31:0] rd_timer2;		// timer2读取数据
		wire irq_timer2;				// timer2中断请求
		
		// output of bridge
		wire [31:0] cpuo_prrd;		// 给cpu的读取数据
		wire [7:2] cpuo_hwint;		// 给cpu的中断请求集合
		wire [3:2] timer1o_addr;	// 给timer1的地址
		wire timer1o_we;				// 给timer1的写使能
		wire [31:0] timer1o_wd;		// 给timer1的写数据
		wire [3:2] timer2o_addr;	// 给timer2的地址
		wire timer2o_we;				// 给timer2的写使能
		wire [31:0] timer2o_wd;		// 给timer2的写数据
		
		// link to cpu
		CPU cpu(.Clock(clk),.Reset(reset),
				  .PrRd(cpuo_prrd),.HWInt(cpuo_hwint),
			     .PrWe(prwe),.PrBE(byteenable),.PrAddr(praddr),.PrWd(prwd));
		
		// link to bridge
		Bridge bridge(.CPUI_PrWe(prwe),.CPUI_PrBE(byteenable),.CPUI_PrAddr(praddr),.CPUI_PrWd(prwd),
						  .CPUO_PrRd(cpuo_prrd),.CPUO_HWInt(cpuo_hwint),
						  .TIMER1I_Rd(rd_timer1),.TIMER1I_IRQ(irq_timer1),
						  .TIMER1O_Addr(timer1o_addr),.TIMER1O_We(timer1o_we),.TIMER1O_Wd(timer1o_wd),
						  .TIMER2I_Rd(rd_timer2),.TIMER2I_IRQ(irq_timer2),
						  .TIMER2O_Addr(timer2o_addr),.TIMER2O_We(timer2o_we),.TIMER2O_Wd(timer2o_wd));
						  
		Timer t1(.Clock(clk),.Reset(reset),
				.Addr(timer1o_addr),
				.WE(timer1o_we),
				.WD(timer1o_wd),
				.RD(rd_timer1),
				.IRQ(irq_timer1));
	
		Timer t2(.Clock(clk),.Reset(reset),
				.Addr(timer2o_addr),
				.WE(timer2o_we),
				.WD(timer2o_wd),
				.RD(rd_timer2),
				.IRQ(irq_timer2));
endmodule
/*module mips(clk,reset);
		input clk;
		input reset;
		
		// output of cpu
		wire prwe;						// 写使能信号
		wire [3:0] byteenable;		// 字选信号
		wire [31:0] praddr;			// 地址
		wire [31:0] prwd;				// 写数据
		
		// output of bridge
		wire [31:0] prrd;
		wire [7:2] hwint;
		
		// link to cpu
		CPU cpu(.Clock(clk),.Reset(reset),
				  .PrRd(prrd),.HWInt(hwint),
			     .PrWe(prwe),.PrBE(byteenable),.PrAddr(praddr),.PrWd(prwd));
		
		// link to bridge
		Bridge bridge(.Clock(clk),.Reset(reset),.PrWe(prwe),.PrBE(byteenable),.PrAddr(praddr),.PrWd(prwd),
						  .PrRd(prrd),.HWInt(hwint));
						  
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
endmodule*/
