`timescale 1ns / 1ps
module LED_Driver_tb;

	// Inputs
	reg Clock;
	reg Reset;
	reg WB;
	reg [2:2] Addr;
	reg [31:0] WD;

	// Outputs
	wire [31:0] RD;
	wire [3:0] LTube4_Sel;
	wire [3:0] HTube4_Sel;
	wire STube_Sel;
	wire [7:0] LTube4;
	wire [7:0] HTube4;
	wire [7:0] STube;

	// Instantiate the Unit Under Test (UUT)
	LED_Display_Driver uut (
		.Clock(Clock), 
		.Reset(Reset), 
		.WB(WB), 
		.Addr(Addr), 
		.WD(WD), 
		.RD(RD), 
		.LTube4_Sel(LTube4_Sel), 
		.HTube4_Sel(HTube4_Sel), 
		.STube_Sel(STube_Sel), 
		.LTube4(LTube4), 
		.HTube4(HTube4), 
		.STube(STube)
	);

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 0;
		WB = 1;
		Addr = 0;
		WD = 32'h12345678;
		#40;
		WB = 1;
		Addr = 1;
		WD = 32'hffffffff;
		#40;
		WB = 0;
		Addr = 0;
		WD = 32'haabbccdd;
		
		

	end
	
	always # 20 Clock = ~Clock;
      
endmodule

