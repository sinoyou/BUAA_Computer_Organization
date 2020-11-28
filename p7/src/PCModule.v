/*
version 7.1 2018.12.11 ����NPC������slot�˿ڣ���pc_update�е�ֵ��ӦΪ�ӳٲ�ָ��ʱ��Ч��
version 7.2 2018.12.13 ����NPC������EPC�˿ڣ���������cp0��������epcֵ��
version 7.3 2018.12.19 �޸���NPC��������eret�ӳٲ۵��ж�����eret�����һ��ָ���ӳٲ�ȡ����
*/
`timescale 1ns / 1ps
`include "head.v"
/*
1.ע���֧����pcʱ��������������򷵻ص�ֵһ������˳������beq������Ӧ�÷���pc+8��������pc+4ָ��ᱻ���ε���ȡ��
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
	input Cmp;						// ������֧���ıȽϽ��
	input [`pcsel_size-1:0] nPc_Sel;			// ��ת�������
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
				Pc_Update = (Cmp)?(Pc4+(Im32<<2)):Pc4+4;							// debug!!!!!!!: ��ͬ�ڵ�����cpu��beq������ʱpc+8����Ϊ��ʱpc+4��ָ���Ѿ���ȡ�����ˡ�
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