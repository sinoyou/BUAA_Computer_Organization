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
	wire Alu_Error;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.AluOp(AluOp), 
		.A(A), 
		.B(B), 
		.C(C), 
		.Result(Result),
		.Alu_Error(Alu_Error)
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
		// test for add overflow
		AluOp = 0;
		A = 32'h7fffffff; // 32'h7000ffff
		B = 32'h0000ffff;
		C = 0;
		# 10;
		// test for sub overflow
		AluOp = 1;
		A = 32'h80000001;
		B = 32'h0000ffff;
		C = 1;
		# 10;
		// test for overflow number in non-overflow situation
		AluOp = 2;
		A = 32'h80000001;
		B = 32'h0000ffff;
		C = 1;
		# 10;
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

