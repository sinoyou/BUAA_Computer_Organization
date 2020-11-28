`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:54:04 10/27/2018
// Design Name:   ext
// Module Name:   H:/ISE_projects/p1_homework/ext_tb.v
// Project Name:  p1_homework
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ext
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ext_tb;

	// Inputs
	reg [15:0] imm;
	reg [1:0] EOp;

	// Outputs
	wire [31:0] ext;

	// Instantiate the Unit Under Test (UUT)
	ext uut (
		.imm(imm), 
		.EOp(EOp), 
		.ext(ext)
	);

	initial begin
		// Initialize Inputs
		imm = 16'hf000;
		EOp = 00;
		# 100;
		imm = 16'hf000;
		EOp = 01;
		# 100;
		imm = 16'hf000;
		EOp = 10;
		# 100;
		imm = 16'hf000;
		EOp = 11; 
		// Add stimulus here

	end
      
endmodule

