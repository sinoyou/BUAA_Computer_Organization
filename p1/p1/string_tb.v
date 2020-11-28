`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:11:48 10/27/2018
// Design Name:   string
// Module Name:   H:/ISE_projects/p1_homework/string_tb.v
// Project Name:  p1_homework
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: string
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module string_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] in;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	string uut (
		.clk(clk), 
		.clr(reset), 
		.in(in), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		in = 0;
		
		in = "1";
		# 10;
		in = "+";
		# 10;
		in = "2";
		# 10;
		in = "*";
		# 10;
		in = "3";
		#25;
		reset = 1;
		#10;
		reset = 0;
		in = "1";
		#10;
		in = "+";
		#10;
		in = "2";
		#10;
		in = "*";
		#10;
		in = "3";
		
		
        
		// Add stimulus here

	end
	
	always #5 clk = ~clk;
      
endmodule

