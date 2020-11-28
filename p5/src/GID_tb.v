`timescale 1ns / 1ps
`include "HAZARD.v"

module GID_tb;

	// Inputs
	reg [31:0] IR;
	reg [2:0] Pipe;

	// Outputs
	wire [2:0] Tuse_Rs;
	wire [2:0] Tuse_Rt;
	wire RegWriteNonZero;
	wire [4:0] A3;
	wire [2:0] Tnew;
	wire [2:0] DPort;

	// Instantiate the Unit Under Test (UUT)
	GID uut (
		.IR(IR), 
		.Pipe(Pipe), 
		.Tuse_Rs(Tuse_Rs), 
		.Tuse_Rt(Tuse_Rt), 
		.RegWriteNonZero(RegWriteNonZero), 
		.A3(A3), 
		.Tnew(Tnew), 
		.DPort(DPort)
	);

	initial begin
		// Initialize Inputs
		IR = 0;
		Pipe = 1;
		# 10;
		IR=32'h01084821;
		#10;
		IR=32'h352a000a;
		#10;
		IR=32'h8d4b0000;
		#10;
		IR=32'had6b0000;
		#10;
		IR=32'h116b0000;
		#10;
		IR=32'h08000c05;
		#10;
		IR=32'h01600008;
		#10;
		IR=32'h0c000c05;
		#10;
		Pipe = 2;
		# 10;
		IR=32'h01084821;
		#10;
		IR=32'h352a000a;
		#10;
		IR=32'h8d4b0000;
		#10;
		IR=32'had6b0000;
		#10;
		IR=32'h116b0000;
		#10;
		IR=32'h08000c05;
		#10;
		IR=32'h01600008;
		#10;
		IR=32'h0c000c05;
		#10;
		Pipe = 3;
		# 10;
		IR=32'h01084821;
		#10;
		IR=32'h352a000a;
		#10;
		IR=32'h8d4b0000;
		#10;
		IR=32'had6b0000;
		#10;
		IR=32'h116b0000;
		#10;
		IR=32'h08000c05;
		#10;
		IR=32'h01600008;
		#10;
		IR=32'h0c000c05;
		#10;
		Pipe = 4;
		# 10;
		IR=32'h01084821;
		#10;
		IR=32'h352a000a;
		#10;
		IR=32'h8d4b0000;
		#10;
		IR=32'had6b0000;
		#10;
		IR=32'h116b0000;
		#10;
		IR=32'h08000c05;
		#10;
		IR=32'h01600008;
		#10;
		IR=32'h0c000c05;


        
		// Add stimulus here

	end
      
endmodule

