`timescale 1ns / 1ps
`include "head.v"

// 模块类型：组合逻辑
// 实现方式：always语句实现组合逻辑
module ALU(
	 input [`aluop_size-1:0] AluOp, 						// Alu运算驱动信号
    input [31:0] A, 							// 32位操作数1
    input [31:0] B, 							// 32位操作数2
    input [4:0] C, 							// 5位操作数（常用于移位处理）
    output reg [31:0] Result 				// 32位运算结果
    );
	 
	 always @(*)begin
		case(AluOp)
			0:										// add : add,addu,addi,addiu,ld,st
				begin Result = A + B; end
			1:										// sub: subu,subu
				begin Result = A - B; end
			2:										// sll: sll(nop)
				begin Result = B << C; end				
			3:										// srl: srl
				begin Result = B >> C; end
			4:										// sra: sra
				begin Result = $signed($signed(B) >>> C); end
			5:										// sllv: sllv
				begin Result = B << A[4:0]; end
			6:										// srlv: srlv
				begin Result = B >> A[4:0]; end
			7:										// srav: srav
				begin Result = $signed($signed(B) >>> A[4:0]); end
			8: 									// and: and,andi
				begin Result = (A & B); end
			9:										// or: or,ori
				begin Result = (A | B); end
			10:									// xor: xor,xori
				begin Result = (A ^ B); end
			11: 									// nor: nor
				begin Result = ~(A | B); end
			12:									// slt: slt, slti
				begin Result = $signed(($signed(A)<$signed(B))?1:0); end
			13:									// sltu: sltu,sltiu
				begin Result = (A<B)?1:0; end
			14:									// shift16: lui
				begin Result = (B<<16);	 end
			15:									// =B+4:jal,jalr(delay bench)
				begin Result = B + 4; end
			default:
				begin Result = 0; end
		endcase
	 end
endmodule
