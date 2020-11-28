`timescale 1ns / 1ps
`include "ALU.v"

module ALU_tb;

	// Inputs
	reg [3:0] AluOp;
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
		// test for add
		A = 100;
		B = -10;
		# 10;
		A = 32'h70000000;
		B = 32'h70000000;
		# 10;
		A = 32'h80000000;
		B = 32'h80000000;
		# 10;
		
		// test for sub
		AluOp = 1;
		A = 32'h0000ffff;
		B = 32'h0000fff0;
		# 10;
		A = 32'h8000000f;
		B = 32'h000000f0;
		#10;
		
		// test for or
		AluOp = 2;
		A = 32'hff00000b;
		B = 32'h00ff000a;
		#10;
		
		// test for eql
		AluOp = 3;
		A = 3;
		B = 5;
		# 10;
		A = -3;
		B = -10010101;
		# 10;
		A = 198123;
		B = 198123;
		#10;
		
		// test for shift 
		AluOp = 4;
		A = 3;
		B = 1;
		# 10;
		
		// test for =A
		AluOp = 5;
		A = 101;
		B = 102;
		# 10;
	
		// test for sll
		AluOp = 6;
		A = 3;
		B = 1;
		C = 7;
		
        
		// Add stimulus here

	end
      
endmodule

