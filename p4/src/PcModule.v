`timescale 1ns / 1ps
// Jump÷∏¡Ó∆¥∫œ
module Jump(JIm,PCHead,JumpPC);
	input [25:0] JIm;
	input [3:0] PCHead;
	output [31:0] JumpPC;
	
	assign JumpPC  = {PCHead[3:0], JIm[25:0], 2'b00};
endmodule

// branch pc calculate
module Nadd(Pc4, Im, Out);
	input [31:0] Pc4;
	input [31:0] Im;
	output [31:0] Out;
	assign Out = Pc4 + (Im<<2);
endmodule
