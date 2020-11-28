`timescale 1ns / 1ps

module timer_tb;

	// Inputs
	reg Clock;
	reg Reset;
	reg [3:2] Addr;
	reg WE;
	reg [31:0] WD;

	// Outputs
	wire [31:0] RD;
	wire IRQ;

	// Instantiate the Unit Under Test (UUT)
	Timer uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.Addr(Addr), 
		.WE(WE), 
		.WD(WD), 
		.RD(RD), 
		.IRQ(IRQ)
	);

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		Addr = 0;
		WE = 0;
		WD = 0;
		
		Addr = 1;
		WD = 5;
		WE = 1;
		# 10;
		
		Addr = 0;
		WD[2:1] = 1;
		WD[0] = 1;
		WD[3] = 1;
		# 10;
		WE = 0;

	end
	always #5 Clock = ~Clock;
      
endmodule

