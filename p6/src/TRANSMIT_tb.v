`timescale 1ns / 1ps
`include "HAZARD.v"
module TRANSMIT_tb;

	// Inputs
	reg [31:0] FD_IR;
	reg [31:0] DE_IR;
	reg [31:0] EM_IR;
	reg [31:0] MW_IR;

	// Outputs
	wire [2:0] TMux_GRF_RD1;
	wire [2:0] TMux_GRF_RD2;
	wire [2:0] TMux_DE_RD1;
	wire [2:0] TMux_DE_RD2;
	wire [2:0] TMUX_EM_RD2;

	// Instantiate the Unit Under Test (UUT)
	TRANSMIT uut (
		.FD_IR(FD_IR), 
		.DE_IR(DE_IR), 
		.EM_IR(EM_IR), 
		.MW_IR(MW_IR), 
		.TMux_GRF_RD1(TMux_GRF_RD1), 
		.TMux_GRF_RD2(TMux_GRF_RD2), 
		.TMux_DE_RD1(TMux_DE_RD1), 
		.TMux_DE_RD2(TMux_DE_RD2), 
		.TMux_EM_RD2(TMUX_EM_RD2)
	);

	initial begin
/*00430821
00000000
1022fff5

00024940
00000000
1041fff2

00430823
00000000
00000000
00200008

8c010000
00000000
00000000
1022ffea

01430823
00221021

3c010064
ac220000

8c010000
00000000
ac220000

34410064
00000000
00010821

0c000c04
00000000
afe10000

8c010000
ac010000

3c010064
ac010000
*/







		// 1
		FD_IR = 32'h1022fff5;
		DE_IR = 32'h00000000;
		EM_IR = 32'h00430821;
		MW_IR = 32'h00000000;

		// 2
		#10;
		// Initialize Inputs
		FD_IR = 32'h1041fff2;
		DE_IR = 32'h00000000;
		EM_IR = 32'h00024940;
		MW_IR = 32'h00000000;

		//3
		#10;
		
		FD_IR = 32'h00200008;
		DE_IR = 32'h00000000;
		EM_IR = 32'h00000000;
		MW_IR = 32'h00430823;

		//4
		#10;
		
		FD_IR = 32'h1022ffea;
		DE_IR = 32'h00000000;
		EM_IR = 32'h00000000;
		MW_IR = 32'h8c010000;

		// 5
		#10;
		
		FD_IR = 32'h00000000;
		DE_IR = 32'h00221021;
		EM_IR = 32'h01430823;
		MW_IR = 32'h00000000;

		// 6
		#10;
		FD_IR = 32'h00000000;
		DE_IR = 32'hac220000;
		EM_IR = 32'h3c010064;
		MW_IR = 32'h00000000;

		// 7
		#10;
		FD_IR = 32'h00000000;
		DE_IR = 32'hac220000;
		EM_IR = 32'h00000000;
		MW_IR = 32'h8c010000;

		// 8
		#10;
		FD_IR = 32'h00000000;
		DE_IR = 32'h00010821;
		EM_IR = 32'h00000000;
		MW_IR = 32'h34410064;
		
		// 9
		#10;
		FD_IR = 32'h00000000;
		DE_IR = 32'hafe10000;
		EM_IR = 32'h00000000;
		MW_IR = 32'h0c000c04;	

		// 10
		#10;
		FD_IR = 32'h00000000;
		DE_IR = 32'h00000000;
		EM_IR = 32'hac010000;
		MW_IR = 32'h8c010000;	
		
		// 11
		#10;
		FD_IR = 32'h00000000;
		DE_IR = 32'h00000000;
		EM_IR = 32'hac210000;
		MW_IR = 32'h3c010064;	
		
		// 12
		#10;
		FD_IR = 32'h00000000;
		DE_IR = 32'h00000000;
		EM_IR = 32'hac200000;
		MW_IR = 32'h3c000064;	
	end
      
endmodule

