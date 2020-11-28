/*
version 7.1 2018.12.11 新增NPC部件的slot端口，当pc_update中的值对应为延迟槽指令时有效。
version 7.2 2018.12.13 新增NPC部件的EPC端口，接受来自cp0处理器的epc值。
version 7.3 2018.12.19 修改了NPC部件对于eret延迟槽的判定，将eret后跟的一条指令延迟槽取消。
*/
`timescale 1ns / 1ps
`include "head.v"
/*
1.注意分支更新pc时，如果不成立，则返回的值一定符合顺序（例如beq不成立应该返回pc+8），否则pc+4指令会被两次地提取。
*/
module CMP(CmpOp,A,B,Cmp);
	input [`cmpop_size-1:0] CmpOp;
	input [31:0] A;
	input [31:0] B;
	output Cmp;
	
	assign Cmp = (CmpOp == 0)?(A==B):				// beq
					 (CmpOp == 1)?(A!=B):				// bne
					 (CmpOp == 2)?($signed(A)<=0):	// blez
					 (CmpOp == 3)?($signed(A)>0):		// bgtz
					 (CmpOp == 4)?($signed(A)<0):		// bltz
					 (CmpOp == 5)?($signed(A)>=0):	// bgez
					 0;				 
endmodule


module NPC(Cmp,nPc_Sel,Im32,Im26,Pc4,RegPc,EPC,Pc_Update,Slot);
	input Cmp;						// 条件分支语句的比较结果
	input [`pcsel_size-1:0] nPc_Sel;			// 跳转语句类型
	input [31:0] Im32;			// for branch
	input [25:0] Im26;			// for j, jal,
	input [31:0] Pc4;				// for j,jal
	input [31:0] RegPc;			// for jr
	input [31:0] EPC;				// for eret
	output reg [31:0] Pc_Update;
	output Slot;
	
	assign Slot =  (nPc_Sel==0)?			  1:
						(nPc_Sel==1)?			  1:
						(nPc_Sel==2)?			  1:
						(nPc_Sel==3)?			  0:
													  0;
	
	always @(*)begin
		case(nPc_Sel)
			0:							// branch
				Pc_Update = (Cmp)?(Pc4+(Im32<<2)):Pc4+4;							// debug!!!!!!!: 不同于单周期cpu，beq不成立时pc+8，因为此时pc+4的指令已经被取出来了。
			1:							// j&jal
				Pc_Update = {Pc4[31:28],Im26[25:0],2'b00};
			2:							// jr&jalr
				Pc_Update = RegPc;
			3:							// eret
				Pc_Update = EPC;
			default:
				Pc_Update = Pc4;
		endcase
	end
endmodule
