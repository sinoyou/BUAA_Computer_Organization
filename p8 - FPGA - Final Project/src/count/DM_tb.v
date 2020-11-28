`timescale 1ns / 1ps

module DM_tb;

	// Inputs
	reg Clock;
	reg Reset;
	reg [3:0] ByteEnable;
	reg [31:0] WPC;
	reg [31:0] Addr;
	reg [31:0] WD;

	// Outputs
	wire [31:0] RD;

	// Instantiate the Unit Under Test (UUT)
	DM uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.ByteEnable(ByteEnable), 
		.WPC(WPC), 
		.Addr(Addr), 
		.WD(WD), 
		.RD(RD)
	);

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		ByteEnable = 0;
		WPC = 0;
		Addr = 0;
		WD = 0;

		// Wait 100 ns for global reset to finish
		#180;
		Addr = 2002;
		WD = 32'h11223344;
		ByteEnable = 4'b1100;
		# 80;
		Addr = 3000;
		WD = 32'haabbccdd;
		ByteEnable = 0;
		# 80;
		Addr = 2000;
		ByteEnable = 0;
        
		// Add stimulus here

	end
	always #20 Clock = ~Clock;
      
endmodule

