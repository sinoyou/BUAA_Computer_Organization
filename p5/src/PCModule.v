`timescale 1ns / 1ps
/*
1.注意分支更新pc时，如果不成立，则返回的值一定符合顺序（例如beq不成立应该返回pc+8），否则pc+4指令会被两次地提取。
*/
module CMP(CmpOp,A,B,Cmp);
	input CmpOp;
	input [31:0] A;
	input [31:0] B;
	output Cmp;
	
	assign Cmp = (CmpOp == 0)?(A==B):0;			// beq
					 
endmodule


module NPC(Cmp,nPc_Sel,Im32,Im26,Pc4,RegPc,Pc_Update);
	input Cmp;						// 条件分支语句的比较结果
	input [2:0] nPc_Sel;			// 跳转语句类型
	input [31:0] Im32;			// for branch
	input [25:0] Im26;			// for j, jal,
	input [31:0] Pc4;				// for j,jal
	input [31:0] RegPc;			// for jr
	output reg [31:0] Pc_Update;
	
	always @(*)begin
		case(nPc_Sel)
			0:							// branch
				Pc_Update = (Cmp)?(Pc4+(Im32<<2)):Pc4+4;							// debug!!!!!!!: 不同于单周期cpu，beq不成立时pc+8，因为此时pc+4的指令已经被取出来了。
			1:							// j&jal
				Pc_Update = {Pc4[31:28],Im26[25:0],2'b00};
			2:							// jr
				Pc_Update = RegPc;
			default:
				Pc_Update = Pc4;
		endcase
	end
endmodule
