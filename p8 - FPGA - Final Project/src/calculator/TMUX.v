/*
version 7.1 2018.12.12 新增了4号数据管口，来自MW寄存器层的CP0内容
*/
`timescale 1ns / 1ps
`include "head.v"
module TMUX(Sel,Ori,EM_Alu,MW_Alu,MW_MD,MW_CP0,Forward);
	input [`tmux_size-1:0] Sel;
	input [31:0] Ori;
	input [31:0] EM_Alu;
	input [31:0] MW_Alu;
	input [31:0] MW_MD;
	input [31:0] MW_CP0;
	output [31:0] Forward;
	
	assign Forward = (Sel==0)?Ori:
						  (Sel==1)?EM_Alu:
						  (Sel==2)?MW_Alu:
						  (Sel==3)?MW_MD:
						  (Sel==4)?MW_CP0:
						  Ori;

endmodule
