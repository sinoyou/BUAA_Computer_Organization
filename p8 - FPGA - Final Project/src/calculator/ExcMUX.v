/*
version 7.2 - 2018.12.15 - �޸���EMUX_F�����Ľӿ���������
version 7.4 - 2018.12.17 - �޸���EMUX-E��EMUX-M����쳣��������⣬load��ָ���store��ָ����쳣�����ǲ�ͬ�ġ�
*/
`timescale 1ns / 1ps
`include "head.v"
`include "instr_list.v"

module EMUX_F(IF_Error,F_Exc);
	input IF_Error;
	output [6:2] F_Exc;
	assign {F_Exc} = (IF_Error)?{5'd4}:
											{5'd0};
endmodule

module EMUX_D(IDU_Error,FD_Exc,D_Exc);
	input IDU_Error;
	input [6:2] FD_Exc;
	output [6:2] D_Exc;
	assign {D_Exc} = (FD_Exc!=0)?	{FD_Exc[6:2]}:
						  (IDU_Error)?	{5'd10}:
											{FD_Exc[6:2]};
endmodule

module EMUX_E(IR,Alu_Error,DE_Exc,E_Exc);
	input [31:0] IR;
	input Alu_Error;
	input [6:2] DE_Exc;
	output [6:2] E_Exc;
	
	wire [`irn_size-1:0] irn;
	wire [`irtype_size-1:0] irtype;
	
	IDU Idu(.IR(IR),.IRN(irn),.IRType(irtype));
	
	// ��ALU����������ź�Ҫ��������ۣ�1��ֻ��ĳЩָ�������� 2��st��ld����ָ�����������ַ�����쳣.
	assign {E_Exc} =  (DE_Exc!=0)?												  		  		{DE_Exc[6:2]}:
							(Alu_Error &&( irn==`add || irn==`sub || irn==`addi) )? 		{5'd12}:
							(Alu_Error && (irtype==`ld))?			  								{5'd4 }:
							(Alu_Error && (irtype==`st))?			  								{5'd5 }:
																											{DE_Exc[6:2]};
endmodule


module EMUX_M(IR,MOV_Error,EM_Exc,M_Exc);
	input [31:0] IR;
	input MOV_Error;				// memory operation verify ģ������ź�
	input [6:2] EM_Exc;
	output [6:2] M_Exc;
	
	wire [`irn_size-1:0] irn;
	wire [`irtype_size-1:0] irtype;	
	// �˴���Ҫָ��������ɸѡ����ΪLD��STORE��ָ����쳣��һ��.
	IDU Idu(.IR(IR),.IRN(irn),.IRType(irtype));
	assign {M_Exc} =	(EM_Exc!=0)?   				{EM_Exc[6:2]}:
							(MOV_Error&&irtype==`ld)?	{5'd4}:
							(MOV_Error&&irtype==`st)?	{5'd5}:
																{EM_Exc[6:2]};
endmodule
