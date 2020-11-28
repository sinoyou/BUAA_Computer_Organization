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
	wire ld_align,ld_timer,ld_range;
	wire st_align,st_timer,st_count,st_range;
	
	// output : error
	assign MOV_Error = ld_align | ld_range | ld_timer | st_align | st_count | st_range | st_timer;
	
	// 错误识别 
	// 取数异常-lw-没有4字节对齐	// 取数异常-lh、lhu-没有2字节对齐
	assign ld_align = (irn==`lw && Addr[1:0]!=0) || ((irn==`lh||irn==`lhu) && Addr[0]!=0);
	// 取数异常-ld-超范围0x0000~0x2ffc以及 0x7F00~0X7F0B 和 0x7F10~0X7F1B
	assign ld_range = (irtype==`ld && ~( (Addr>=32'h00000000&&Addr<=32'h00002ffc)|| 
													 (Addr>=32'h00007f00&&Addr<=32'h00007f0b)|| 
													 (Addr>=32'h00007f10&&Addr<=32'h00007f1b)));
	// 取数异常-lh-lhu-lb-lbu取timer值
	assign ld_timer = ((irn==`lh || irn==`lhu || irn==`lb || irn==`lbu) &&
							((Addr>=32'h00007f00&&Addr<=32'h00007f0b) || (Addr>=32'h00007f10&&Addr<=32'h00007f1b)));
	// 存数异常-lw-没有4字节对齐  // 存数异常-sh-没有2字节对齐
	assign st_align = (irn==`sw && Addr[1:0]!=0) || ((irn==`sh) && Addr[0]!=0);
	// 存数异常-st-向count中存值
	assign st_count = ((irtype==`st) && ( (Addr>=32'h00007f08&&Addr<=32'h00007f0b) || (Addr>=32'h00007f18&&Addr<=32'h00007f1b) ));
	// 存数异常-st-超范围0x0000~0x2ffc以及 0x7F00~0X7F0B 和 0x7F10~0X7F1B
	assign st_range = (irtype==`st && ~( (Addr>=32'h00000000&&Addr<=32'h00002ffc)|| 
													 (Addr>=32'h00007f00&&Addr<=32'h00007f0b)|| 
													 (Addr>=32'h00007f10&&Addr<=32'h00007f1b)));
	// 存数异常-sh、sb-向timer中存值
	assign st_timer = ((irn==`sh || irn==`sb) &&
							((Addr>=32'h00007f00&&Addr<=32'h00007f0b) || (Addr>=32'h00007f10&&Addr<=32'h00007f1b)));

endmodule
