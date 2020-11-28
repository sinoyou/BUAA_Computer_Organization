`timescale 1ns / 1ps

module CP0_tb;

	// Inputs
	reg Clock;
	reg Reset;
	reg WE;
	reg ExlSet;
	reg ExlClr;
	reg [4:0] RA;
	reg [4:0] WA;
	reg [31:0] WD;
	reg [31:0] PC;
	reg [6:2] ExcCode;
	reg BD;
	reg [5:0] HWInt;

	// Outputs
	wire IntReq;
	wire [31:0] EPC;
	wire [31:0] RD;

	// Instantiate the Unit Under Test (UUT)
	CP0 uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.WE(WE), 
		.ExlSet(ExlSet), 
		.ExlClr(ExlClr), 
		.RA(RA), 
		.WA(WA), 
		.WD(WD), 
		.PC(PC), 
		.ExcCode(ExcCode), 
		.BD(BD), 
		.HWInt(HWInt), 
		.IntReq(IntReq), 
		.EPC(EPC), 
		.RD(RD)
	);

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		WE = 0;
		ExlSet = 0;
		ExlClr = 0;
		RA = 0;
		WA = 0;
		WD = 0;
		PC = 0;
		ExcCode = 0;
		BD = 0;
		HWInt = 0;

		// Wait 100 ns for global reset to finish
		WE = 1;
		ExlSet = 0;
		RA = 12;
		WA = 12;
		WD = 32'h0000fc01;
		PC = 32'h0000300f;
		ExcCode = 0;
		BD = 1;
		HWInt = 6'b000001;
		# 10;
		WE = 1;
		ExlSet = 1;
		RA = 12;
		WA = 12;
		WD = 32'hffffffff;
		PC = 32'h0000300f;
		ExcCode = 0;
		BD = 1;
		HWInt = 6'b000001;
		# 10;
		WE = 1;
		ExlSet = 0;
		RA = 14;
		WA = 14;
		WD = 32'h00003000;
		PC = 32'h00004180;
		ExcCode = 4;
		BD = 0;
		HWInt = 6'b110000;
		# 10;
		WE = 0;
		ExlClr = 1;
		RA = 12;
		WA = 14;
		WD = 32'h00003100;
		PC = 32'h00004184;
		ExcCode = 4;
		BD = 0;
		HWInt = 6'b000000;
		# 10;
		ExlClr = 0;
		// Add stimulus here

	end
	
	always #5 Clock = ~Clock;
      
endmodule

