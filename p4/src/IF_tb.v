`timescale 1ns / 1ps
`include "IF.v"
module IF_tb;

	// Inputs
	reg Branch_Jump;
	reg Clock;
	reg Reset;
	reg [31:0] PC_Update;

	// Outputs
	wire [31:0] PC;
	wire [31:0] Instr;

	// Instantiate the Unit Under Test (UUT)
	IF uut (
		.Branch_Jump(Branch_Jump), 
		.Clock(Clock), 
		.Reset(Reset), 
		.PC_Update(PC_Update), 
		.PC(PC), 
		.Instr(Instr)
	);

	initial begin
		// Initialize Inputs
		Branch_Jump = 0;
		Clock = 0;
		Reset = 0;
		PC_Update = 0;
		
		# 60; // pc + 4 + 4 + 4
		PC_Update = 32'h00003fff;
		# 20;
		Branch_Jump = 1;
		# 20;
		Branch_Jump = 0;
		# 20;
		Reset = 1;

	end
	
	always #10 Clock = ~Clock;
      
endmodule

