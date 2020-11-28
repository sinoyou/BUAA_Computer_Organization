`timescale 1ns / 1ps
`include "DM.v"

module DM_tb;

	// Inputs
	reg MemWrite;
	reg MemRead;
	reg Clock;
	reg Reset;
	reg [31:0] WPC;
	reg [31:0] Addr;
	reg [31:0] WD;

	// Outputs
	wire [31:0] RD;

	// Instantiate the Unit Under Test (UUT)
	DM uut (
		.MemWrite(MemWrite), 
		.MemRead(MemRead), 
		.Clock(Clock), 
		.Reset(Reset), 
		.WPC(WPC), 
		.Addr(Addr), 
		.WD(WD), 
		.RD(RD)
	);

	initial begin
		// Initialize Inputs
		MemWrite = 0;
		MemRead = 1;
		Clock = 0;
		Reset = 0;
		WPC = 0;
		Addr = 0;
		WD = 0;
        
		// Add stimulus here
		#20;
		WD = 1;
		Addr = 1*4;
		
		#20;
		MemWrite = 1;
		WD = 2;
		Addr = 0;
		
		#20;
		WD = 1024;
		Addr = 1023*4;
		
		#20;
		Addr = 1022*4;
		WD = 1022;
		
		#20;
		Addr = 0;
		MemWrite = 0;
		
		# 20;
		MemRead = 1;
		
		#20;
		Addr = 1023*4;
		
		#20;
		Addr = 1022*4;
		
		#20;
		Reset = 1;
		
		#20;						// ±ß¶Á±ßÐ´¹¦ÄÜ
		Reset = 0;
		WD = 100;
		MemWrite = 1;
		MemRead = 1;
		Addr = 0;
		
		#20;
		MemRead = 0;
		MemWrite = 0;
		

	end
	always #10 Clock = ~Clock;
      
endmodule

