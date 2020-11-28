`timescale 1ns / 1ps
`include "head.v"
module MCtrl_tb;

	// Inputs
	reg [5:0] Op;
	reg [5:0] Func;
	reg [4:0] Rt;

	// Outputs
	wire Branch_Jump;
	wire [2:0] nPc_Sel;
	wire [1:0] AluSrc;
	wire MemRead;
	wire MemWrite;
	wire RegWrite;
	wire [1:0] WaSel;
	wire [1:0] WdSel;
	wire ExtOp;
	wire [4:0] AluOp;
	wire [1:0] AluSel;
	wire [1:0] Start;
	wire [2:0] XAluOp;
	wire [1:0] Store_Type;
	wire [1:0] Load_Type;
	wire Sign_Read;
	wire [2:0] CmpOp;
	
	reg [31:0] ins;

	// Instantiate the Unit Under Test (UUT)
	Main_Controller uut (
		.Op(Op), 
		.Func(Func), 
		.Rt(Rt), 
		.Branch_Jump(Branch_Jump), 
		.nPc_Sel(nPc_Sel), 
		.AluSrc(AluSrc), 
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.RegWrite(RegWrite), 
		.WaSel(WaSel), 
		.WdSel(WdSel), 
		.ExtOp(ExtOp), 
		.CmpOp(CmpOp), 
		.AluOp(AluOp), 
		.AluSel(AluSel), 
		.Start(Start), 
		.XAluOp(XAluOp), 
		.Store_Type(Store_Type), 
		.Load_Type(Load_Type), 
		.Sign_Read(Sign_Read)
	);

	initial begin
		// Initialize Inputs
		Op = 0;
		Func = 0;
		Rt = 0;
		ins=0;

		// Wait 100 ns for global reset to finish
		ins = 32'h08000c32;
		Op = ins[`op];
		Func = ins[`func];
		Rt = ins[`rt];
		# 10;
		ins = 32'h0c000c32;
		Op = ins[`op];
		Func = ins[`func];
		Rt = ins[`rt];
		# 10;
		ins = 32'h03e00008;
		Op = ins[`op];
		Func = ins[`func];
		Rt = ins[`rt];
		# 10;
		ins = 32'h00400809;
		Op = ins[`op];
		Func = ins[`func];
		Rt = ins[`rt];
		# 10;

		
		
		

        
		// Add stimulus here

	end
      
endmodule

