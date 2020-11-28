`timescale 1ns / 1ps
`include "HAZARD.v"

module STALL_tb;

	// Inputs
	reg [31:0] FD_IR;
	reg [31:0] DE_IR;
	reg [31:0] EM_IR;
	reg [31:0] MW_IR;

	// Outputs
	wire Stall;

	// Instantiate the Unit Under Test (UUT)
	STALL uut (
		.FD_IR(FD_IR), 
		.DE_IR(DE_IR), 
		.EM_IR(EM_IR), 
		.MW_IR(MW_IR), 
		.Stall(Stall)
	);

	initial begin
		// Initialize Inputs
		FD_IR = 0;
		DE_IR = 0;
		EM_IR = 0;
		MW_IR = 0;

		// Wait 100 ns for global reset to finish
		#10;
		DE_IR = 32'h8c410000;
		FD_IR = 32'h00221023;
		
		#10;
		DE_IR = 32'h8c610000;
		FD_IR = 32'h34020001;
		
		#10;
		DE_IR = 32'h8c410000;
		FD_IR = 32'h8c220000;
		
		#10;
		DE_IR = 32'h8c410000;
		FD_IR = 32'hac220000;
		
		#10;
		DE_IR = 32'h8c410000;
		FD_IR = 32'hac010000;
		
		#10;
		DE_IR = 32'h8c010000;
		FD_IR = 32'h10410010;
		
		#10;
		DE_IR = 32'h8c010000;
		FD_IR = 32'h00200008;
		
		#10;
		DE_IR = 32'h00430821;
		FD_IR = 32'h1022000c;
		
		#10;
		DE_IR = 32'h34010064;
		FD_IR = 32'h1041000a;
		
		#10;
		DE_IR = 32'h00430821;
		FD_IR = 32'h00200008;
		
		#10;
		DE_IR = 32'h3c01000f;
		FD_IR = 32'h00200008;
		
		#10;
		EM_IR = 32'h8c210000;
		DE_IR = 32'h00000000;
		FD_IR = 32'h10220003;
		
		#10;
		EM_IR = 32'h8c210000;
		DE_IR = 32'h00000000;
		FD_IR = 32'h00200008;
        
		// Add stimulus here

	end
      
endmodule

