`timescale 1ns / 1ps
`include "ALU.v"

module ALU_tb;

	// Inputs
	reg [4:0] AluOp;
	reg [31:0] A;
	reg [31:0] B;
	reg [4:0] C;

	// Outputs
	wire [31:0] Result; 

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.AluOp(AluOp), 
		.A(A), 
		.B(B), 
		.C(C), 
		.Result(Result)
	);

	initial begin
		// Initialize Inputs
		AluOp = 0;
		A = 0;
		B = 0;
		C = 0;
		// use monitor to show value easily
		$monitor("AluOp = %d, A = %h, B = %h, C = %d, Result = %h", AluOp, A,B,C,Result);
		// Wait 100 ns for global reset to finish
		#10;
		// test for slt
		AluOp = 12;
		A = -10;
		B = 100;
		C = 5;
		# 10;
		// test for sra
		AluOp = 4;
		A = -10;
		B = -1019283;
		C = 3;
		#10;
		// test for srav
		AluOp = 7;
		A = -10198;
		B = 100;
		C = 3;

	end
      
endmodule

