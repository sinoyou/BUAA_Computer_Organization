`timescale 1ns / 1ps


module STALL_tb;

	// Inputs
	reg [31:0] FD_IR;
	reg [31:0] DE_IR;
	reg [31:0] EM_IR;
	reg [31:0] MW_IR;
	reg Busy;
	reg [1:0] Start;

	// Outputs
	wire Stall;

	// Instantiate the Unit Under Test (UUT)
	STALL uut (
		.FD_IR(FD_IR), 
		.DE_IR(DE_IR), 
		.EM_IR(EM_IR), 
		.MW_IR(MW_IR), 
		.Stall(Stall),
		.E_Busy(Busy),
		.E_Start(Start)
	);

	initial begin
		// Initialize Inputs
		FD_IR = 0;
		DE_IR = 0;
		EM_IR = 0;
		MW_IR = 0;
		Busy = 0;
		Start = 0;

		// Wait 100 ns for global reset to finish
		#10;
		DE_IR = 32'h8c410000;
		FD_IR = 32'h00221022;
		
		#10;
		DE_IR = 32'h84620000;
		FD_IR = 32'h34430001;
		
		#10;
		DE_IR = 32'h80410000;
		FD_IR = 32'h8c220000;
		
		#10;
		DE_IR = 32'h94410000;
		FD_IR = 32'ha4220000;
		
		#10;
		DE_IR = 32'h90410000;
		FD_IR = 32'hac010000;
		
		#10;
		DE_IR = 32'h8c010000;
		FD_IR = 32'h1041001f;
		
		#10;
		DE_IR = 32'h8c010000;
		FD_IR = 32'h00200008;
		
		#10;
		DE_IR = 32'h8c010000;
		FD_IR = 32'h0020f809;
		
		#10;
		DE_IR = 32'h00430821;
		FD_IR = 32'h10220019;
		
		#10;
		DE_IR = 32'h34010064;
		FD_IR = 32'h1c200017;
		
		#10;
		DE_IR = 32'h00430821;
		FD_IR = 32'h00200008;

		#10;
		DE_IR = 32'h3c01000f;
		FD_IR = 32'h00200008;
	
		#10;
		DE_IR = 32'h00620807;
		FD_IR = 32'h0020f809;
		
		#10;
		DE_IR = 32'h38010000;
		FD_IR = 32'h0020f809;
		
		#10;
		EM_IR = 32'h90210000;
		DE_IR = 32'h00000000;
		FD_IR = 32'h1422000c;
		
		#10;
		EM_IR = 32'h94210000;
		DE_IR = 32'h00000000;
		FD_IR = 32'h00200008;
		
		#10;
		EM_IR = 32'h80210000;
		DE_IR = 32'h00000000;
		FD_IR = 32'h0020f809;
		
		#10;
		EM_IR = 32'h94210000;
		DE_IR = 32'h00000000;
		FD_IR = 32'h00200008;
		
		#10;
		Busy  = 1;
		FD_IR = 32'h00001810;
		Busy  = 0;
		
		#10;
		DE_IR = 32'h0022001a;
		FD_IR = 32'h00600013;
		
		#10;
		DE_IR = 32'h00200013;
		FD_IR = 32'h00001012;
        
		// Add stimulus here

	end
      
endmodule

