`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:40:55 10/30/2018
// Design Name:   debug_two_always
// Module Name:   H:/ISE_projects/p1_homework/debug_two_always_tb.v
// Project Name:  p1_homework
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: debug_two_always
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module debug_two_always_tb;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire p;

	// Instantiate the Unit Under Test (UUT)
	debug_two_always uut (
		.clk(clk), 
		.reset(reset), 
		.p(p)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;

        
		// Add stimulus here

	end
	
	always #5 clk = ~clk;
	always #5 reset = ~reset;
      
endmodule

