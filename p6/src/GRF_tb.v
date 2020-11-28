`timescale 1ns / 1ps
`include "GRF.v"

module GRF_tb;

	// Inputs
	reg RegWrite;
	reg Clock;
	reg Reset;
	reg [4:0] RA1;
	reg [4:0] RA2;
	reg [4:0] WA;
	reg [31:0] WD;

	// Outputs
	wire [31:0] RD1;
	wire [31:0] RD2;

	// Instantiate the Unit Under Test (UUT)
	GRF uut (
		.RegWrite(RegWrite), 
		.Clock(Clock), 
		.Reset(Reset), 
		.RA1(RA1), 
		.RA2(RA2), 
		.WA(WA), 
		.WD(WD), 
		.RD1(RD1), 
		.RD2(RD2)
	);
	
	integer i;
	
	initial begin
		// Initialize Inputs
		RegWrite = 0;
		Clock = 0;
		Reset = 0;
		RA1 = 0;
		RA2 = 0;
		WA = 0;
		WD = 0;
		i = 0;
        
		# 10;
		RegWrite = 1;								// write enable
		RA1 = 5;										// read address stay but value change
		RA2 = 6;
		for(i=0;i<=31;i=i+1)begin
			WA = i;
			WD = i+1;
			# 10;
		end
		
		RegWrite = 0;								// write disable
		WA = 5;
		WD = 100;
		# 10;
		WA = 6;
		WD = 200;
		# 10;
		
		for(i=0;i<=31;i=i+1)begin				// read addr change but value stay
			RA1 = i;
			RA2 = 31-i;
			if(i==16)Reset = 1;
			# 10;
		end
		

	end
	always #5 Clock = ~Clock;
      
endmodule

