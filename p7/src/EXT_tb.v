`timescale 1ns / 1ps
`include "EXT.v"
module EXT_tb;

	// Inputs
	reg ExtOp;
	reg [15:0] Input;

	// Outputs
	wire [31:0] Output;

	// Instantiate the Unit Under Test (UUT)
	EXT uut (
		.ExtOp(ExtOp), 
		.Input(Input), 
		.Output(Output)
	);

	initial begin
		// Initialize Inputs
		ExtOp = 0;
		Input = 0;

		// Wait 100 ns for global reset to finish
		#10;
      Input = 10;
		# 10;
		Input = -1;
		# 10;
		ExtOp = 1;
		Input = 10;
		# 10;
		Input = -10;
		// Add stimulus here

	end
      
endmodule

