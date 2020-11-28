`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:42:52 10/27/2018
// Design Name:   debug
// Module Name:   H:/ISE_projects/p1_homework/debug_tb.v
// Project Name:  p1_homework
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: debug
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module debug_tb;

	// Inputs
	reg [7:0] in;
	reg clk;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	debug uut (
		.in(in), 
		.clk(clk), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		clk = 0;
		
		in = "1";
		#10;
		in = "+";

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	always #5 clk = ~clk;
      
endmodule

