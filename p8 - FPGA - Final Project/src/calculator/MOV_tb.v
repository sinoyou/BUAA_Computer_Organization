`timescale 1ns / 1ps
module MOV_tb;

	// Inputs
	reg [31:0] IR;
	reg [31:0] Addr;

	// Outputs
	wire Mem_Error;

	// Instantiate the Unit Under Test (UUT)
	MOV uut (
		.IR(IR), 
		.Addr(Addr), 
		.Mem_Error(Mem_Error)
	);

	initial begin
		// Initialize Inputs
		IR = 0;
		Addr = 0;
		// lw-align
		IR = 32'h8c000000;
		Addr = 32'h00000001;
		#10;
		// lh-align
		IR = 32'h84000000;
		Addr = 32'h00000001;
		#10;
		// lhu-align
		IR = 32'h94000000;
		Addr = 32'h00000001;
		#10;
		// lw-range
		IR = 32'h8c000000;
		Addr = 32'h00003028;
		#10;
		// lh-range
		IR = 32'h84000000;
		Addr = 32'h00007f0c;
		#10;
		// lbu-range
		IR = 32'h90000000;
		Addr = 32'h00007f1c;
		#10;
		// lh-timer
		IR = 32'h84000000;
		Addr = 32'h00007f00;
		#10;
		// lhu-timer
		IR = 32'h94000000;
		Addr = 32'h00007f10;
		#10;
		// lb-timer
		IR = 32'h80000000;
		Addr = 32'h00007f0b;
		#10;
		// lbu-timer
		IR = 32'h90000000;
		Addr = 32'h00007f1b;
		#10;
		// sw-align
		IR = 32'hac000000;
		Addr = 32'h00000002;
		#10;
		// sh-align
		IR = 32'ha4000000;
		Addr = 32'h00000003;
		#10;
		// sw-count
		IR = 32'hac000000;
		Addr = 32'h00007f08;
		#10;
		// sh-count
		IR = 32'ha4000000;
		Addr = 32'h00007f1a;
		#10;
		// sb-count
		IR = 32'ha0000000;
		Addr = 32'h00007f0b;
		#10;
		// sw-range
		IR = 32'hac000000;
		Addr = 32'h00007f28;
		#10;
		// sh-range
		IR = 32'ha4000000;
		Addr = 32'h00007f0e;
		#10;
		// sb-range
		IR = 32'ha0000000;
		Addr = 32'h00002ffd;
		#10;
		// sh-timer
		IR = 32'ha4000000;
		Addr = 32'h00007f04;
		#10;
		// sb-timer
		IR = 32'ha0000000;
		Addr = 32'h00007f1a;
		

	end
      
endmodule

