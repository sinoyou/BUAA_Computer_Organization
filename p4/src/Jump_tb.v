`timescale 1ns / 1ps
`include "PcModule.v"

module Jump_tb;

	// Inputs
	reg [25:0] JIm;
	reg [3:0] PCHead;

	// Outputs
	wire [31:0] JumpPC;

	// Instantiate the Unit Under Test (UUT)
	Jump uut (
		.JIm(JIm), 
		.PCHead(PCHead), 
		.JumpPC(JumpPC)
	);

	initial begin
		// Initialize Inputs
		JIm = 0;
		PCHead = 0;

		// Wait 100 ns for global reset to finish
		#100;
		PCHead = 4'habcd;
		JIm = 26'b1100_0011_1010_0101_1000_0001_11;
        
		// Add stimulus here

	end
      
endmodule

