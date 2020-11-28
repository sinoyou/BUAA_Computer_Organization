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
		Pipe = 4;
		
		IR = 32'h00430820;
		#5;
		$display("Pipe 4; AT-add:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00430821;
		#5;
		$display("Pipe 4; AT-addu:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00430822;
		#5;
		$display("Pipe 4; AT-sub:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00430823;
		#5;
		$display("Pipe 4; AT-subu:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00020800;
		#5;
		$display("Pipe 4; AT-sll:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00020802;
		#5;
		$display("Pipe 4; AT-srl:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00020803;
		#5;
		$display("Pipe 4; AT-sra:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00620804;
		#5;
		$display("Pipe 4; AT-sllv:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00620806;
		#5;
		$display("Pipe 4; AT-srlv:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00620807;
		#5;
		$display("Pipe 4; AT-srav:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00430824;
		#5;
		$display("Pipe 4; AT-and:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00430825;
		#5;
		$display("Pipe 4; AT-or:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00430826;
		#5;
		$display("Pipe 4; AT-xor:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00430827;
		#5;
		$display("Pipe 4; AT-nor:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h0043082a;
		#5;
		$display("Pipe 4; AT-slt:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h0043082b;
		#5;
		$display("Pipe 4; AT-sltu:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00220018;
		#5;
		$display("Pipe 4; AT-mult:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00220019;
		#5;
		$display("Pipe 4; AT-multu:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h0022001a;
		#5;
		$display("Pipe 4; AT-div:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h0022001b;
		#5;
		$display("Pipe 4; AT-divu:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00200011;
		#5;
		$display("Pipe 4; AT-mthi:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00200013;
		#5;
		$display("Pipe 4; AT-mtlo:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00000810;
		#5;
		$display("Pipe 4; AT-mfhi:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00000812;
		#5;
		$display("Pipe 4; AT-mflo:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h20410000;
		#5;
		$display("Pipe 4; AT-addi:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h24410000;
		#5;
		$display("Pipe 4; AT-addiu:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h30410000;
		#5;
		$display("Pipe 4; AT-andi:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h34410000;
		#5;
		$display("Pipe 4; AT-ori:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h38410000;
		#5;
		$display("Pipe 4; AT-xori:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h3c010000;
		#5;
		$display("Pipe 4; AT-lui:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h28410000;
		#5;
		$display("Pipe 4; AT-slti:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h2c410000;
		#5;
		$display("Pipe 4; AT-stliu:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h8c410000;
		#5;
		$display("Pipe 4; AT-lw:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h80410000;
		#5;
		$display("Pipe 4; AT-lb:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h90410000;
		#5;
		$display("Pipe 4; AT-lbu:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h84410000;
		#5;
		$display("Pipe 4; AT-lh:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h94410000;
		#5;
		$display("Pipe 4; AT-lhu:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'hac410000;
		#5;
		$display("Pipe 4; AT-sw:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'ha4410000;
		#5;
		$display("Pipe 4; AT-sh:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'ha0410000;
		#5;
		$display("Pipe 4; AT-sb:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h10220009;
		#5;
		$display("Pipe 4; AT-beq:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h14220008;
		#5;
		$display("Pipe 4; AT-bne:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h18200007;
		#5;
		$display("Pipe 4; AT-blez:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h1c200006;
		#5;
		$display("Pipe 4; AT-bgtz:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h04200005;
		#5;
		$display("Pipe 4; AT-bltz:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h04210004;
		#5;
		$display("Pipe 4; AT-bgez:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h08000c32;
		#5;
		$display("Pipe 4; AT-j:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h0c000c32;
		#5;
		$display("Pipe 4; AT-jal:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h03e00008;
		#5;
		$display("Pipe 4; AT-jr:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;
		IR = 32'h00400809;
		#5;
		$display("Pipe 4; AT-jalr:Tuse_Rs=%d; Tuse_Rt=%d; RWNZ=%d; A3=%d; Tnew=%d; DPort=%d;",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		#10;





        
		// Add stimulus here

	end
      
endmodule

