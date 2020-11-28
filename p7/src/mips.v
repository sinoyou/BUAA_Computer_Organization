/*
version 7.6 2018.12.19 ������timer1��timer2������ģ�飬�޸���bridge���ӣ�ԭ���������б���
*/
`timescale 1ns / 1ps
// `include "Control.v"
// `include "datapath.v"
`include "head.v"

module mips(clk,reset);
		input clk;
		input reset;
		
		// output of cpu
		wire prwe;						// дʹ���ź�
		wire [3:0] byteenable;		// ��ѡ�ź�
		wire [31:0] praddr;			// ��ַ
		wire [31:0] prwd;				// д����
		
		// output of timer1
		wire [31:0] rd_timer1;		// timer1��ȡ����
		wire irq_timer1;				// timer1�ж�����
		
		// output of timer2
		wire [31:0] rd_timer2;		// timer2��ȡ����
		wire irq_timer2;				// timer2�ж�����
		
		// output of bridge
		wire [31:0] cpuo_prrd;		// ��cpu�Ķ�ȡ����
		wire [7:2] cpuo_hwint;		// ��cpu���ж����󼯺�
		wire [3:2] timer1o_addr;	// ��timer1�ĵ�ַ
		wire timer1o_we;				// ��timer1��дʹ��
		wire [31:0] timer1o_wd;		// ��timer1��д����
		wire [3:2] timer2o_addr;	// ��timer2�ĵ�ַ
		wire timer2o_we;				// ��timer2��дʹ��
		wire [31:0] timer2o_wd;		// ��timer2��д����
		
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
		wire prwe;						// дʹ���ź�
		wire [3:0] byteenable;		// ��ѡ�ź�
		wire [31:0] praddr;			// ��ַ
		wire [31:0] prwd;				// д����
		
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
