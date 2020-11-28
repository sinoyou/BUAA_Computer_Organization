`timescale 1ns / 1ps
/*
1.ע���֧����pcʱ��������������򷵻ص�ֵһ������˳������beq������Ӧ�÷���pc+8��������pc+4ָ��ᱻ���ε���ȡ��
*/
module CMP(CmpOp,A,B,Cmp);
	input CmpOp;
	input [31:0] A;
	input [31:0] B;
	output Cmp;
	
	assign Cmp = (CmpOp == 0)?(A==B):0;			// beq
					 
endmodule


module NPC(Cmp,nPc_Sel,Im32,Im26,Pc4,RegPc,Pc_Update);
	input Cmp;						// ������֧���ıȽϽ��
	input [2:0] nPc_Sel;			// ��ת�������
	input [31:0] Im32;			// for branch
	input [25:0] Im26;			// for j, jal,
	input [31:0] Pc4;				// for j,jal
	input [31:0] RegPc;			// for jr
	output reg [31:0] Pc_Update;
	
	always @(*)begin
		case(nPc_Sel)
			0:							// branch
				Pc_Update = (Cmp)?(Pc4+(Im32<<2)):Pc4+4;							// debug!!!!!!!: ��ͬ�ڵ�����cpu��beq������ʱpc+8����Ϊ��ʱpc+4��ָ���Ѿ���ȡ�����ˡ�
			1:							// j&jal
				Pc_Update = {Pc4[31:28],Im26[25:0],2'b00};
			2:							// jr
				Pc_Update = RegPc;
			default:
				Pc_Update = Pc4;
		endcase
	end
endmodule
