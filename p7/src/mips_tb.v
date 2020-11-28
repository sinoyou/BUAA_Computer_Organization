`timescale 1ns / 1ps

module mips_tb;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
        
		// Add stimulus here

	end
	always #0.5 clk = ~clk;
      
endmodule

