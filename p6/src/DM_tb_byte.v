`timescale 1ns / 1ps
`include "DM.v"
module DM_tb_byte;

	// Inputs
	reg MemWrite;
	reg MemRead;
	reg [1:0] StoreType;
	reg [1:0] LoadType;
	reg SignRead;
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
		.StoreType(StoreType), 
		.LoadType(LoadType), 
		.SignRead(SignRead), 
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
		MemRead = 0;
		StoreType = 0;
		LoadType = 0;
		SignRead = 0;
		Clock = 0;
		Reset = 0;
		WPC = 0;
		Addr = 0;
		WD = 0;
		#10;
		// 1 0x123456678
		MemWrite = 1;
		MemRead = 0;
		StoreType = 0;
		LoadType = 0;
		SignRead = 0;
		WPC = 0;
		Addr = 0;
		WD = 32'h12345678;
		#10;
		// 2 0xaabb5678
		MemWrite = 1;
		MemRead = 0;
		StoreType = 1;
		LoadType = 0;
		SignRead = 0;
		WPC = 0;
		Addr = 2;
		WD = 32'h0000aabb;
		#10;
		// 3 0xaabb56dd
		MemWrite = 1;
		MemRead = 0;
		StoreType = 2;
		LoadType = 0;
		SignRead = 0;
		WPC = 0;
		Addr = 0;
		WD = 32'haabbccdd;
		#10;
		// 3 0xeebb56dd
		MemWrite = 1;
		MemRead = 0;
		StoreType = 2;
		LoadType = 0;
		SignRead = 0;
		WPC = 0;
		Addr = 3;
		WD = 32'haabbccee;
		#10;
		// 5 -> RD = 0xffffffdd
		MemWrite = 0;
		MemRead = 1;
		StoreType = 0;
		LoadType = 2;
		SignRead = 1;
		WPC = 0;
		Addr = 0;
		WD = 32'h12345678;
		#10;
		// 6 -> RD = 0x000000dd
		MemWrite = 0;
		MemRead = 1;
		StoreType = 0;
		LoadType = 2;
		SignRead = 0;
		WPC = 0;
		Addr = 0;
		WD = 32'h12345678;
		#10;
		// 7 -> RD = 0x000000dd
		MemWrite = 0;
		MemRead = 1;
		StoreType = 0;
		LoadType = 2;
		SignRead = 0;
		WPC = 0;
		Addr = 0;
		WD = 32'h12345678;
		#10;		
		// 8 -> RD = 0x000056dd
		MemWrite = 0;
		MemRead = 1;
		StoreType = 0;
		LoadType = 1;
		SignRead = 1;
		WPC = 0;
		Addr = 0;
		WD = 32'h12345678;
		#10;	
		// 9 -> RD = 0x000056dd
		MemWrite = 0;
		MemRead = 1;
		StoreType = 0;
		LoadType = 1;
		SignRead = 0;
		WPC = 0;
		Addr = 0;
		WD = 32'h12345678;
		#10;
		// 10 -> RD = 0xffffeebb
		MemWrite = 0;
		MemRead = 1;
		StoreType = 0;
		LoadType = 1;
		SignRead = 1;
		WPC = 0;
		Addr = 2;
		WD = 32'h12345678;
		#10;
		// 11 -> RD = 0xeebb78dd -> 0x12345678
		MemWrite = 1;
		MemRead = 1;
		StoreType = 0;
		LoadType = 0;
		SignRead = 1;
		WPC = 0;
		Addr = 0;
		WD = 32'h12345678;
		#10;			
        
		// Add stimulus here

	end
	
	always #5 Clock = ~Clock;
      
endmodule

