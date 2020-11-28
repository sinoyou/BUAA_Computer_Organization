`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:12:42 10/27/2018
// Design Name:   alu
// Module Name:   H:/ISE_projects/p1_homework/alu_tb.v
// Project Name:  p1_homework
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_tb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [2:0] ALUOp;

	// Outputs
	wire [31:0] C;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.A(A), 
		.B(B), 
		.ALUOp(ALUOp), 
		.C(C)
	);

	initial begin
		// Initialize Inputs
		A = 32'hf0_00_00_10;
		B = 2;
		ALUOp = 3'b101;
		# 100;
		A = 32'hf0_00_00_10;
		B = 32'h00_00_00_10;
		ALUOp = 3'b000;
		# 100;
		A = 32'h00_00_00_01;
		B = 32'h00_00_00_10;
		ALUOp = 3'b001;
		# 100;
		A = 32'he0_00_01_01;
		B = 32'hf0_00_01_10;
		ALUOp = 3'b010;
		# 100;
		A = 32'h00_00_00_01;
		B = 32'h00_00_00_10;
		ALUOp = 3'b011;
		# 100;
		A = 32'hf0_00_00_01;
		B = 32'h00_00_00_10;
		ALUOp = 3'b100;			
        
		// Add stimulus here

	end
      
endmodule

