`timescale 1ns / 1ps
`include "head.v"
module TMUX(Sel,Ori,EM_Alu,MW_Alu,MW_MD,Forward);
	input [`tmux_size-1:0] Sel;
	input [31:0] Ori;
	input [31:0] EM_Alu;
	input [31:0] MW_Alu;
	input [31:0] MW_MD;
	output [31:0] Forward;
	
	assign Forward = (Sel==0)?Ori:
						  (Sel==1)?EM_Alu:
						  (Sel==2)?MW_Alu:
						  (Sel==3)?MW_MD:
						  Ori;

endmodule
