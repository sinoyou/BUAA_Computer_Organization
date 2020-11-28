`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:22:49 10/31/2018
// Design Name:   debug_zongxian
// Module Name:   H:/ISE_projects/p1_homework/debug_zongxian_tb.v
// Project Name:  p1_homework
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: debug_zongxian
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module debug_zongxian_tb;

	// Outputs
	wire [7:0] out;

	// Instantiate the Unit Under Test (UUT)
	debug_zongxian uut (
		.out(out)
	);
	// parameter [7:0] lsfr_taps [7 : 0] = {8'd9, 8'd5, 8'd3, 8'h21, 8'd9, 8'd9, 8'd5, 8'd9};
	parameter [7:0] lsfr_taps = 8'd9;
	reg signed [7:0] a;
	reg signed [7:0] b;
	reg c;
	reg clk;
	
	initial begin
		// Initialize Inputs

		// Wait 100 ns for global reset to finish
		#100;
		clk = 0;
		$monitor("value of a and b is %b %b",a,clk);
      a = lsfr_taps;
		b = 8'b00000001;
		$display(" value of b %b", b, "time = ", $time);
		
		c = (b < a);
		// Add stimulus here

	end
	always #10 clk = ~clk;
      
endmodule

