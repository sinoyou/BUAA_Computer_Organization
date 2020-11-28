`timescale 1ns / 1ps


module XALU_tb;

	// Inputs
	reg Clock;
	reg Reset;
	reg Start;
	reg [2:0] XALUOp;
	reg [31:0] RD1;
	reg [31:0] RD2;

	// Outputs
	wire Busy;
	wire [31:0] HI;
	wire [31:0] LO;

	// Instantiate the Unit Under Test (UUT)
	XALU uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.Start(Start), 
		.XALUOp(XALUOp), 
		.Busy(Busy), 
		.RD1(RD1), 
		.RD2(RD2), 
		.HI(HI), 
		.LO(LO)
	);

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		Start = 0;
		XALUOp = 0;
		RD1 = 0;
		RD2 = 0;
		
		// mult: neg * pos
		Start = 1;
		XALUOp = 0;
		RD1 = -7;
		RD2 = 13;
		# 10;
		Start = 0;
		XALUOp = 4;
		RD1 = 1;
		RD2 = 2;
		# 50;
		
		// mult: neg * neg
		Start = 1;
		XALUOp = 0;
		RD1 = -7;
		RD2 = -10;
		# 10;
		Start = 0;
		XALUOp = 4;
		RD1 = 1;
		RD2 = 2;
		# 50;
		
		// multu: neg * pos
		Start = 1;
		XALUOp = 1;
		RD1 = -7;
		RD2 = 13;
		# 10;
		Start = 0;
		XALUOp = 4;
		RD1 = 1;
		RD2 = 2;
		# 50;
        
		// multu: pos * pos
		Start = 1;
		XALUOp = 1;
		RD1 = 1937298193;
		RD2 = 1201019822;
		# 10;
		Start = 0;
		XALUOp = 4;
		RD1 = 1;
		RD2 = 2;
		# 50;
		
		// div: pos/pos
		Start = 1;
		XALUOp = 2;
		RD1 = 8;
		RD2 = 3;
		# 10;
		Start = 0;
		XALUOp = 4;
		RD1 = 1;
		RD2 = 2;
		# 100;
		
		// div: neg/pos
		Start = 1;
		XALUOp = 2;
		RD1 = -8;
		RD2 = 3;
		# 10;
		Start = 0;
		XALUOp = 4;
		RD1 = 1;
		RD2 = 2;
		# 100;
		
		// div: pos/neg
		Start = 1;
		XALUOp = 2;
		RD1 = 8;
		RD2 = -3;
		# 10;
		Start = 0;
		XALUOp = 4;
		RD1 = 1;
		RD2 = 2;
		# 100;
		
		// divu:neg/neg
		Start = 1;
		XALUOp = 3;
		RD1 = -8;
		RD2 = -198;
		# 10;
		Start = 0;
		XALUOp = 4;
		RD1 = 1;
		RD2 = 2;
		# 100;
		
		// mthi -> 100
		Start = 1;
		XALUOp = 4;
		RD1 = 100;
		RD2 = 200;
		# 10;
		// mtlo -> 300
		Start = 1;
		XALUOp = 5;
		RD1 = 300;
		RD2 = 400;
		# 10;
		Start = 0;
		RD1 = 9;

	end
	
	always #5 Clock = ~Clock;
      
endmodule

