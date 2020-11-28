/*
version 7.6 2018.12.19 上移了timer1和timer2至顶层模块，修改了bridge连接，原本连线留有备份
version 8.0 2018.12.24 引入了clock core核心
version 8.0 2018.12.25 删除了timer2部件及其连线,新增了key，switch，display，led四个部件及其接口
version 8.0 2018.12.27 新增了uart部件及其接口（中断请求暂时未添加，只能通过轮询方式访问）
*/
`timescale 1ns / 1ps
`include "head.v"

module mips(clk_in,sys_rstn,
				uart_rxd,uart_txd,
				dip_switch0,dip_switch1,dip_switch2,dip_switch3,
				dip_switch4,dip_switch5,dip_switch6,dip_switch7,
				user_key,
				led_light,
				digital_tube0,digital_tube1,digital_tube2,
				digital_tube_sel0,digital_tube_sel1,digital_tube_sel2);
		
		// sys ctrl
		input clk_in;
		input sys_rstn;
		// uart
		input uart_rxd;
		output uart_txd;
		// dip
		input [7:0] dip_switch0;
		input [7:0] dip_switch1;
		input [7:0] dip_switch2;
		input [7:0] dip_switch3;
		input [7:0] dip_switch4;
		input [7:0] dip_switch5;
		input [7:0] dip_switch6;
		input [7:0] dip_switch7;
		// key
		input [7:0] user_key;
		// led32
		output [31:0] led_light;
		// display
		output [7:0] digital_tube0;
		output [7:0] digital_tube1;
		output [7:0] digital_tube2;
		output [3:0] digital_tube_sel0;
		output [3:0] digital_tube_sel1;
		output 		 digital_tube_sel2;
		
		// 系统级控制变量译码
		wire clk;
		wire reset;
		wire clk_1;
		wire clk_2;
		assign clk = clk_in;
		assign reset = ~sys_rstn;
		// link to clock-core
		Clock_Core a_clock_core
		(.CLK_IN1(clk),      // IN
		 .CLK_OUT1(clk_1),     // OUT
		 .CLK_OUT2(clk_2));    // OUT
		
		
		// 请注意：所有定义的网格型变量均是mips内部的连线，其与外部设备交互的连线（无论输入输出）将直接调用端口信号
		
		// output of cpu
		wire prwe;						// 写使能信号
		wire [3:0] prbe;				// 字选信号
		wire [31:0] praddr;			// 地址
		wire [31:0] prwd;				// 写数据
		
		// output of timer1
		wire [31:0] rd_timer1;		// timer1读取数据
		wire irq_timer1;				// timer1中断请求
		
		// output of uart
		wire [31:0] rd_uart;
		wire irq_uart;
		
		// output of key
		wire [31:0] rd_key;
		
		// output of switch
		wire [31:0] rd_switch;
		
		// output of led32
		wire [31:0] rd_led32;
		
		// output of display
		wire [31:0] rd_display;
		
		// output of bridge
		wire [31:0] cpuo_prrd;		// 给cpu的读取数据
		wire [7:2] cpuo_hwint;		// 给cpu的中断请求集合
		wire [3:2] timer1o_addr;	// 给timer1的地址（读+写）
		wire timer1o_we;				// 给timer1的写使能
		wire [31:0] timer1o_wd;		// 给timer1的写数据
		wire [4:2] uarto_addr;		// 给uart的写地址
		wire uarto_we_stb;			// 给uart的写使能兼Slave信号
		wire [31:0] uarto_wd;		// 给uart的写数据
		wire switcho_addr;			// 给switch的地址（读）
		wire led32o_we;				// 给led的写使能
		wire [31:0] led32o_wd;		// 给led的写数据
		wire displayo_addr;			// 给display的地址（读+写）
		wire displayo_we;				// 给display的写使能
		wire [31:0] displayo_wd;	// 给display的写数据
		
		// link to bridge
		Bridge b_bridge(.CPUI_PrWe(prwe),.CPUI_PrBE(prbe),.CPUI_PrAddr(praddr),.CPUI_PrWd(prwd),
						  .CPUO_PrRd(cpuo_prrd),.CPUO_HWInt(cpuo_hwint),
						  .TIMER1I_Rd(rd_timer1),.TIMER1I_IRQ(irq_timer1),
						  .TIMER1O_Addr(timer1o_addr),.TIMER1O_We(timer1o_we),.TIMER1O_Wd(timer1o_wd),
						  .UARTI_Rd(rd_uart),.UARTI_IRQ(irq_uart),
						  .UARTO_Addr(uarto_addr),.UARTO_We_STB(uarto_we_stb),.UARTO_Wd(uarto_wd),
						  .KEYI_Rd(rd_key),
						  .SWITCHI_Rd(rd_switch),
						  .SWITCHO_Addr(switcho_addr),
						  .LED32I_Rd(rd_led32),
						  .LED32O_We(led32o_we),.LED32O_Wd(led32o_wd),
						  .DISPLAYI_Rd(rd_display),
						  .DISPLAYO_Addr(displayo_addr),.DISPLAYO_We(displayo_we),.DISPLAYO_Wd(displayo_wd));
						  
		// link to cpu
		CPU c_cpu(.Clock(clk_1),.Reset(reset),.Clock_2(clk_2),
				  .PrRd(cpuo_prrd),.HWInt(cpuo_hwint),
			     .PrWe(prwe),.PrBE(prbe),.PrAddr(praddr),.PrWd(prwd));
		
		// link to timer1				  
		Timer d_t1(.Clock(clk_1),.Reset(reset),
					.Addr(timer1o_addr),
					.WE(timer1o_we),
					.WD(timer1o_wd),
					.RD(rd_timer1),
					.IRQ(irq_timer1));
		
		// link to uart
		MiniUART d_mini_uart (
			 .ADD_I(uarto_addr), 	// I 地址[4:2]
			 .DAT_I(uarto_wd), 		// I 输入数据 [31:0]
			 .STB_I(uarto_we_stb),  // I slave 信号 功能与WE一致
			 .WE_I(uarto_we_stb),  	// I 写使能信号
			 .CLK_I(clk_1), 			// I 时钟信号
			 .RST_I(reset), 			// I 异步复位信号
		  //.ACK_O(ACK_O), 			// O 握手信号 完全照搬STB_I
			 .DAT_O(rd_uart), 		// O 输出数据 [31:0]
			 .INT_O(irq_uart),		// O 中断请求
			 .RxD(uart_rxd), 			// O 外部交流信号，读，Input
			 .TxD(uart_txd)			// O 外部交流信号，写，Output
			 );
		
		// link to key
		Key_Driver d_key_driver(.RD(rd_key),
									 // 外联
									 .Key(user_key));
									 
		// link to switch
		Switch_Driver d_switch_driver(.Addr(switcho_addr),
											 .RD(rd_switch),
											 // 外联
											 .Switch0(dip_switch0),
											 .Switch1(dip_switch1),
											 .Switch2(dip_switch2),
											 .Switch3(dip_switch3),
											 .Switch4(dip_switch4),
											 .Switch5(dip_switch5),
											 .Switch6(dip_switch6),
											 .Switch7(dip_switch7));
											 
		// link to led32
		LED_32_Driver d_led32_driver(.Clock(clk_1),.Reset(reset),.WD(led32o_wd),.WE(led32o_we),
											.RD(rd_led32),
											// 外联
											.Tube32(led_light));
		
		// link to display
		Display_Driver d_display_driver(.Clock(clk_1),.Reset(reset),.WE(displayo_we),.Addr(displayo_addr),.WD(displayo_wd),
												.RD(rd_display),
												// 外联
												.LTube4_Sel(digital_tube_sel0),
												.HTube4_Sel(digital_tube_sel1),
												.STube_Sel(digital_tube_sel2),
												.LTube4(digital_tube0),
												.HTube4(digital_tube1),
												.STube(digital_tube2));
		
	
endmodule
