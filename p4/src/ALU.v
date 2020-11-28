`timescale 1ns / 1ps
// ģ�����ͣ�����߼�
// ʵ�ַ�ʽ��always���ʵ������߼�
module ALU(
	 input [3:0] AluOp, 						// Alu���������ź�
    input [31:0] A, 							// 32λ������1
    input [31:0] B, 							// 32λ������2
    input [4:0] C, 							// 5λ����������������λ����
    output reg [31:0] Result 				// 32λ������
    );
	 
	 always @(*)begin
		case(AluOp)
			0:										// add : addu, lw, sw
				begin Result = A + B; end
			1:										// sub: subu
				begin Result = A - B; end
			2:										// or : ori
				begin Result = A | B; end				
			3:										// logic compare '=': beq
				begin Result = (A==B); end
			4:										// shift16: lui
				begin Result = B << 16; end
			5:										// =A : jr
				begin Result = A; end
			6:										// left shift : sll
				begin Result = B << C; end
			default:
				begin Result = 0; end
		endcase
	 end


endmodule
