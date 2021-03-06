`timescale 1ns / 1ps
// 模块类型：组合逻辑
// 实现方式：always语句实现组合逻辑
module ALU(
	 input [3:0] AluOp, 						// Alu运算驱动信号
    input [31:0] A, 							// 32位操作数1
    input [31:0] B, 							// 32位操作数2
    input [4:0] C, 							// 5位操作数（常用于移位处理）
    output reg [31:0] Result 				// 32位运算结果
    );
	 
	 always @(*)begin
		case(AluOp)
			0:										// add : addu, lw, sw
				begin Result = A + B; end
			1:										// sub: subu
				begin Result = A - B; end
			2:										// sll: sll(nop)
				begin Result = B << C; end				
			3:										// or:ori
				begin Result = A | B; end
			4:										// shift16: lui
				begin Result = B << 16; end
			5:										// =B+4:jal(delay bench)
				begin Result = B + 4; end
			default:
				begin Result = 0; end
		endcase
	 end


endmodule
