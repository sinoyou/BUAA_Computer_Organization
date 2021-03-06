`timescale 1ns / 1ps

`include "head.v"
`include "Main_Controller.v"
`include "HAZARD.v"
module Control( FD_IR,DE_IR,EM_IR,MW_IR,Busy,
					 D_Branch_Jump,D_ExtOp,D_CmpOp,D_nPc_Sel,
					 E_AluOp,E_XAluOp,E_Start,E_AluSrc,E_AluSel,
					 M_Store_Type,M_Load_Type,M_SignRead,M_MemRead,M_MemWrite,
					 W_WaSel,W_WdSel,W_RegWrite,
					 Stall,TMux_GRF_RD1_Sel,TMux_GRF_RD2_Sel,TMux_DE_RD1_Sel,TMux_DE_RD2_Sel,TMux_EM_RD2_Sel);
	// pipeline instructions
	input [31:0] FD_IR;
	input [31:0] DE_IR;
	input [31:0] EM_IR;
	input [31:0] MW_IR;
	input Busy;													// new
	
	// main controller signal
	output D_Branch_Jump;
	output D_ExtOp;
	output [`cmpop_size-1:0] D_CmpOp;
	output [`pcsel_size-1:0] D_nPc_Sel;
	output [`aluop_size-1:0] E_AluOp;
	output [`xaluop_size-1:0] E_XAluOp;					// new
	output [`start_size-1:0] E_Start;					// new
	output [`alusrc_size-1:0] E_AluSrc;
	output [`alusel_size-1:0] E_AluSel;					// new
	output [`store_type_size-1:0] M_Store_Type; 		// new
	output [`load_type_size-1:0] M_Load_Type;  		// new
	output M_SignRead;										// new
	output M_MemRead;
	output M_MemWrite;
	output [`wasel_size-1:0] W_WaSel;
	output [`wdsel_size-1:0] W_WdSel;
	output W_RegWrite;
	
	// hazard controller signal
	output Stall;
	output [`tmux_size-1:0]TMux_GRF_RD1_Sel;
	output [`tmux_size-1:0]TMux_GRF_RD2_Sel;
	output [`tmux_size-1:0]TMux_DE_RD1_Sel;
	output [`tmux_size-1:0]TMux_DE_RD2_Sel;
	output [`tmux_size-1:0]TMux_EM_RD2_Sel;
	
	// 控制逻辑
	// 指令流水，分别于D、E、M、W级别
	Main_Controller D_MCtrl(.Op(FD_IR[`op]),.Func(FD_IR[`func]),.Rt(FD_IR[`rt]),
									.Branch_Jump(D_Branch_Jump),.ExtOp(D_ExtOp),.CmpOp(D_CmpOp),.nPc_Sel(D_nPc_Sel)),
						 E_MCtrl(.Op(DE_IR[`op]),.Func(DE_IR[`func]),.Rt(DE_IR[`rt]),
									.AluSrc(E_AluSrc),.XAluOp(E_XAluOp),.Start(E_Start),.AluSel(E_AluSel),.AluOp(E_AluOp)),
						 M_MCtrl(.Op(EM_IR[`op]),.Func(EM_IR[`func]),.Rt(EM_IR[`rt]),
									.MemRead(M_MemRead),.MemWrite(M_MemWrite),.Store_Type(M_Store_Type),.Load_Type(M_Load_Type),.Sign_Read(M_SignRead)),
						 W_MCtrl(.Op(MW_IR[`op]),.Func(MW_IR[`func]),.Rt(MW_IR[`rt]),
									.RegWrite(W_RegWrite),.WaSel(W_WaSel),.WdSel(W_WdSel));
	
	// 冒险-暂停指令控制器STALL(FD_IR,DE_IR,EM_IR,MW_IR,Stall,Start,Busy);
	STALL MyStall(.FD_IR(FD_IR),.DE_IR(DE_IR),.EM_IR(EM_IR),.MW_IR(MW_IR),.Stall(Stall),.E_Start(E_Start),.E_Busy(Busy));
	
	// 冒险-转发指令控制器module TRANSMIT(FD_IR,DE_IR,EM_IR,MW_IR,TMux_GRF_RD1,TMux_GRF_RD2,TMux_DE_RD1,TMux_DE_RD2,TMux_EM_RD2);
	TRANSMIT Transmit(.FD_IR(FD_IR),.DE_IR(DE_IR),.EM_IR(EM_IR),.MW_IR(MW_IR),
					 .TMux_GRF_RD1(TMux_GRF_RD1_Sel),.TMux_GRF_RD2(TMux_GRF_RD2_Sel),
					 .TMux_DE_RD1(TMux_DE_RD1_Sel),.TMux_DE_RD2(TMux_DE_RD2_Sel),
					 .TMux_EM_RD2(TMux_EM_RD2_Sel));

endmodule
