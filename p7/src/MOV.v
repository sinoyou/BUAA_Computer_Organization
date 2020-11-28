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
	
	// ����������M�η����Ĵ�������
	wire ld_align,ld_timer,ld_range;
	wire st_align,st_timer,st_count,st_range;
	
	// output : error
	assign MOV_Error = ld_align | ld_range | ld_timer | st_align | st_count | st_range | st_timer;
	
	// ����ʶ�� 
	// ȡ���쳣-lw-û��4�ֽڶ���	// ȡ���쳣-lh��lhu-û��2�ֽڶ���
	assign ld_align = (irn==`lw && Addr[1:0]!=0) || ((irn==`lh||irn==`lhu) && Addr[0]!=0);
	// ȡ���쳣-ld-����Χ0x0000~0x2ffc�Լ� 0x7F00~0X7F0B �� 0x7F10~0X7F1B
	assign ld_range = (irtype==`ld && ~( (Addr>=32'h00000000&&Addr<=32'h00002ffc)|| 
													 (Addr>=32'h00007f00&&Addr<=32'h00007f0b)|| 
													 (Addr>=32'h00007f10&&Addr<=32'h00007f1b)));
	// ȡ���쳣-lh-lhu-lb-lbuȡtimerֵ
	assign ld_timer = ((irn==`lh || irn==`lhu || irn==`lb || irn==`lbu) &&
							((Addr>=32'h00007f00&&Addr<=32'h00007f0b) || (Addr>=32'h00007f10&&Addr<=32'h00007f1b)));
	// �����쳣-lw-û��4�ֽڶ���  // �����쳣-sh-û��2�ֽڶ���
	assign st_align = (irn==`sw && Addr[1:0]!=0) || ((irn==`sh) && Addr[0]!=0);
	// �����쳣-st-��count�д�ֵ
	assign st_count = ((irtype==`st) && ( (Addr>=32'h00007f08&&Addr<=32'h00007f0b) || (Addr>=32'h00007f18&&Addr<=32'h00007f1b) ));
	// �����쳣-st-����Χ0x0000~0x2ffc�Լ� 0x7F00~0X7F0B �� 0x7F10~0X7F1B
	assign st_range = (irtype==`st && ~( (Addr>=32'h00000000&&Addr<=32'h00002ffc)|| 
													 (Addr>=32'h00007f00&&Addr<=32'h00007f0b)|| 
													 (Addr>=32'h00007f10&&Addr<=32'h00007f1b)));
	// �����쳣-sh��sb-��timer�д�ֵ
	assign st_timer = ((irn==`sh || irn==`sb) &&
							((Addr>=32'h00007f00&&Addr<=32'h00007f0b) || (Addr>=32'h00007f10&&Addr<=32'h00007f1b)));

endmodule
