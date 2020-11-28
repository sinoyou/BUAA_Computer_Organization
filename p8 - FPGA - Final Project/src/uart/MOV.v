/*
version 8.0 2018.12.26 引入宏定义规范内存和外设地址范围；新增了key、switch、led、display器件的地址操作判断（溢出和非法存取），删除了timer2的异常判断，目前未添加uart器件。
version 8.0 2018.12.27 新增了uart导致的异常：包括存取越界，半字、字节存取uart，uart的lsr寄存器的存值
*/
`timescale 1ns / 1ps
`include "instr_list.v"
`include "head.v"
//`include "IDU.v"
// memory operation verify
module MOV(IR,Addr,MOV_Error);
	input [31:0] IR;
	input [31:0] Addr;
	output MOV_Error;
	
	wire [`irn_size-1:0] irn;
	wire [`irtype_size-1:0]	irtype;
	
	IDU Idu(.IR(IR),.IRN(irn),.IRType(irtype));
	
	// 定义所有在M段发生的错误类型
	wire ld_align,ld_device,ld_range;
	wire st_align,st_device,st_onlyread,st_range;
	
	// output : error
	assign MOV_Error = ld_align | ld_range | ld_device | st_align | st_onlyread | st_range | st_device;
	
	// 错误识别 
	// 取数异常-lw-没有4字节对齐	// 取数异常-lh、lhu-没有2字节对齐
	assign ld_align = (irn==`lw && Addr[1:0]!=0) || ((irn==`lh||irn==`lhu) && Addr[0]!=0);
	// 取数异常-ld-超范围dm,timer1,switch,led,display,key
	assign ld_range = (irtype==`ld && ~( (Addr>=`dm_begin			&&Addr<=`dm_end)||
													 (Addr>=`timer_begin    &&Addr<=`timer_end)|| 
													 (Addr>=`uart_begin		&&Addr<=`uart_end)||
													 (Addr>=`switch_begin   &&Addr<=`switch_end)|| 
													 (Addr>=`led_begin      &&Addr<=`led_end)||
													 (Addr>=`display_begin  &&Addr<=`display_end)||
													 (Addr>=`key_begin      &&Addr<=`key_end)));
	// 取数异常-lh-lhu-lb-lbu取timer,switch,led,display,key的值
	assign ld_device = ((irn==`lh || irn==`lhu || irn==`lb || irn==`lbu) &&
							((Addr>=`timer_begin   &&Addr<=`timer_end) || 
							 (Addr>=`uart_begin    &&Addr<=`uart_end) ||
							 (Addr>=`switch_begin  &&Addr<=`switch_end) ||
							 (Addr>=`led_begin     &&Addr<=`led_end) ||
							 (Addr>=`display_begin &&Addr<=`display_end) ||
							 (Addr>=`key_begin     &&Addr<=`key_end)
							));
	
	// 存数异常-lw-没有4字节对齐  // 存数异常-sh-没有2字节对齐
	assign st_align = (irn==`sw && Addr[1:0]!=0) || ((irn==`sh) && Addr[0]!=0);
	// 存数异常-st-向timer-count, switch, key, uart-lsr中存值
	assign st_onlyread = ((irtype==`st) && ( (Addr>=`timer_begin+32'h8  &&Addr<=`timer_begin+32'hb) || 
														  (Addr>=`switch_begin       &&Addr<=`switch_end) ||
														  (Addr>=`key_begin      	  &&Addr<=`key_end) ||
														  (Addr>=`uart_begin+16		  &&Addr<=`uart_begin+19)
														 ));
	// 存数异常-st-超范围dm,timer1，switch，led，display，key
	assign st_range = (irtype==`st && ~( (Addr>=`dm_begin      &&Addr<=`dm_end)||
													 (Addr>=`uart_begin	  &&Addr<=`uart_end)||
													 (Addr>=`timer_begin   &&Addr<=`timer_end)|| 
													 (Addr>=`switch_begin  &&Addr<=`switch_end)||
													 (Addr>=`led_begin	  &&Addr<=`led_end)||
													 (Addr>=`display_begin &&Addr<=`display_end)||
													 (Addr>=`key_begin     &&Addr<=`key_end)
													));
	// 存数异常-sh、sb-向timer,switch,led,display,key中存值
	assign st_device = ((irn==`sh || irn==`sb) &&
							((Addr>=`timer_begin     &&Addr<=`timer_end)  || 
							 (Addr>=`uart_begin      &&Addr<=`uart_end)	 ||
							 (Addr>=`switch_begin    &&Addr<=`switch_end) ||
							 (Addr>=`led_begin		 &&Addr<=`led_end)	 ||
							 (Addr>=`display_begin	 &&Addr<=`display_end)||
							 (Addr>=`key_begin		 &&Addr<=`key_end)
							 ));							

endmodule
