`timescale 1ns / 1ps
`include "MUX_FUNC.v"

module MUX_AluSrc_tb;

	// Inputs
	reg [1:0] AluSrc;
	reg [31:0] DE_RD2;
	reg [31:0] DE_Ext;
	reg [31:0] DE_Pc4;

	// Outputs
	wire [31:0] AluB;

	// Instantiate the Unit Under Test (UUT)
	MUX_AluSrc uut (
		.AluSrc(AluSrc), 
		.DE_RD2(DE_RD2), 
		.DE_Ext(DE_Ext), 
		.DE_Pc4(DE_Pc4), 
		.AluB(AluB)
	);

	initial begin
		// Initialize Inputs
		AluSrc = 0;
		DE_RD2 = 0;
		DE_Ext = 0;
		DE_Pc4 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

