`timescale 1ns / 1ps
`include "head.v"
`include "IF.v"
`include "GRF.v"
`include "PCModule.v"
`include "EXT.v"
`include "ALU.v"
`include "DM.v"
`include "MUX_FUNC.v"
`include "PipeLineReg.v"

module Datapath(Clock,Reset,
					 D_Branch_Jump,D_ExtOp,D_CmpOp,D_nPc_Sel,
					 E_AluOp,E_XAluOp,E_Start,E_AluSrc,E_AluSel,
					 M_Store_Type,M_Load_Type,M_SignRead,M_MemRead,M_MemWrite,
					 W_WaSel,W_WdSel,W_RegWrite,
					 Stall,TMux_GRF_RD1_Sel,TMux_GRF_RD2_Sel,TMux_DE_RD1_Sel,TMux_DE_RD2_Sel,TMux_EM_RD2_Sel,
					 FD_IR,DE_IR,EM_IR,MW_IR,Busy);
	// clk and reset
	input Clock;
	input Reset;
	// main controller signal
	input D_Branch_Jump;
	input D_ExtOp;
	input [`cmpop_size-1:0] D_CmpOp;
	input [`pcsel_size-1:0] D_nPc_Sel;
	input [`aluop_size-1:0] E_AluOp;
	input [`xaluop_size-1:0] E_XAluOp;					// new
	input [`start_size-1:0] E_Start;					// new
	input [`alusrc_size-1:0] E_AluSrc;
	input [`alusel_size-1:0] E_AluSel;					// new
	input [`store_type_size-1:0] M_Store_Type; 		// new
	input [`load_type_size-1:0] M_Load_Type;  		// new
	input M_SignRead;										// new
	input M_MemRead;
	input M_MemWrite;
	input [`wasel_size-1:0] W_WaSel;
	input [`wdsel_size-1:0] W_WdSel;
	input W_RegWrite;
	
	// hazard controller signal
	input Stall;
	input [`tmux_size-1:0] TMux_GRF_RD1_Sel;
	input [`tmux_size-1:0] TMux_GRF_RD2_Sel;
	input [`tmux_size-1:0] TMux_DE_RD1_Sel;
	input [`tmux_size-1:0] TMux_DE_RD2_Sel;
	input [`tmux_size-1:0] TMux_EM_RD2_Sel;
	// pipeline instructions
	output [31:0] FD_IR;
	output [31:0] DE_IR;
	output [31:0] EM_IR;
	output [31:0] MW_IR;
	output Busy;										// new
	
	// 每个功能器件为单位，定义其输出内容的网格线路(控制器和多路选择器单独于后面定义)
	// IFU
	wire [31:0] pc4;
	wire [31:0] ir;
	wire [31:0] pc;
	// -------------FD_PIPE -------------
	wire [31:0] FD_ir;
	wire [31:0] FD_pc4;
	wire [31:0] FD_pc;
	// GRF
	wire [31:0] rd1;
	wire [31:0] rd2;
	// NPC
	wire [31:0] pc_update;
	// EXT
	wire [31:0] ext;
	// CMP
	wire cmp;
	// -------------DE_PIPE---------------
	wire [31:0] DE_ir;
	wire [31:0] DE_pc4;
	wire [31:0] DE_rd1;
	wire [31:0] DE_rd2;
	wire [31:0] DE_ext;
	wire [31:0] DE_pc;
	// ALU
	wire [31:0] aluout;
	// XALU	
	wire [31:0] hi;										// new
	wire [31:0] lo;										// new
	wire busy;												// new
	// -------------EM_PIPE---------------
	wire [31:0] EM_ir;
	wire [31:0] EM_rd2;
	wire [31:0] EM_alu;
	wire [31:0] EM_pc;
	// DM
	wire [31:0] md;
	// -------------MW_PIPE---------------
	wire [31:0] MW_ir;
	wire [31:0] MW_md;
	wire [31:0] MW_alu;
	wire [31:0] MW_pc;
	
	// Function MUXs
	wire [31:0] muxalusrc;
	wire [31:0] muxalusel;
	wire [4:0] muxwasel;
	wire [31:0] muxwdsel;
	
	wire [31:0] tmux_grf_rd1;
	wire [31:0] tmux_grf_rd2;
	wire [31:0] tmux_de_rd1;
	wire [31:0] tmux_de_rd2;
	wire [31:0] tmux_em_rd2;
	
	// CPU连线
	// 输出定义
	assign FD_IR = FD_ir;
	assign DE_IR = DE_ir;
	assign EM_IR = EM_ir;
	assign MW_IR = MW_ir;
	assign Busy = busy;
	
	// 数据通路：主元件与流水线寄存器
	// module IF(Branch_Jump,Enable,Clock,Reset,PC_Update,PC4,Instr);
	IF Ifu(.Branch_Jump(D_Branch_Jump),.Enable(~Stall),.Clock(Clock),.Reset(Reset),.PC_Update(pc_update),.PC4(pc4),.Instr(ir),.PC(pc));
	
	
	
	// PIPE:module FD_PIPE(Clock,Reset,Enable,   F_IR,F_Pc4,F_Pc,   FD_IR,FD_Pc4,FD_Pc);
	FD_PIPE FD_pipe(.Clock(Clock),.Reset(Reset),.Enable(~Stall),
						 .F_IR(ir),.F_Pc4(pc4),.F_Pc(pc),
						 .FD_IR(FD_ir),.FD_Pc4(FD_pc4),.FD_Pc(FD_pc));
	// GRF 
	GRF Grf(.RegWrite(W_RegWrite),.Clock(Clock),.Reset(Reset),
							.RA1(FD_ir[`rs]),.RA2(FD_ir[`rt]),
							.WA(muxwasel),.WD(muxwdsel),.WPC(MW_pc),
							.RD1(rd1),.RD2(rd2));
	// EXT(ExtOp, Input, Output);
	EXT Myext(.ExtOp(D_ExtOp),.Input(FD_ir[`im16]),.Output(ext));
	// CMP(CmpOp,A,B,Cmp);
	CMP Mycmp(.CmpOp(D_CmpOp),.A(tmux_grf_rd1),.B(tmux_grf_rd2),.Cmp(cmp));
	// NPC module NPC(Cmp,nPc_Sel,Im32,Im26,Pc4,RegPc,Pc_Update);
	NPC Npc(.Cmp(cmp),.nPc_Sel(D_nPc_Sel),.Im32(ext),.Im26(FD_ir[`im26]),.Pc4(FD_pc4),.RegPc(tmux_grf_rd1),.Pc_Update(pc_update));
	
	
	
	// PIPE:module DE_PIPE(Clock,Reset,Enable,    D_IR,D_RD1,D_RD2,D_Ext,D_Pc4,D_Pc,    DE_IR,DE_RD1,DE_RD2,DE_Ext,DE_Pc4,DE_Pc);
	DE_PIPE DE_pipe(.Clock(Clock),.Reset(Reset|Stall),.Enable(1'b1),
						 .D_IR(FD_ir),.D_RD1(tmux_grf_rd1),.D_RD2(tmux_grf_rd2),.D_Ext(ext),.D_Pc4(FD_pc4),.D_Pc(FD_pc),
						 .DE_IR(DE_ir),.DE_RD1(DE_rd1),.DE_RD2(DE_rd2),.DE_Ext(DE_ext),.DE_Pc4(DE_pc4),.DE_Pc(DE_pc));
	// ALU
	ALU Alu(.AluOp(E_AluOp),.A(tmux_de_rd1),.B(muxalusrc),.C(DE_ir[`s]),.Result(aluout));
	// XALU
	XALU XAlu(.Clock(Clock),.Reset(Reset),.Start(E_Start),.XALUOp(E_XAluOp),.Busy(busy),.RD1(tmux_de_rd1),.RD2(muxalusrc),.HI(hi),.LO(lo));
	
	
	
	// PIPE:module EM_PIPE(Clock,Reset,Enable,   E_IR,E_RD2,E_ALU,E_Pc,   EM_IR,EM_RD2,EM_ALU,EM_Pc);
	EM_PIPE EM_pipe(.Clock(Clock),.Reset(Reset),.Enable(1'b1),
					.E_IR(DE_ir),.E_RD2(tmux_de_rd2),.E_ALU(muxalusel),.E_Pc(DE_pc),
					.EM_IR(EM_ir),.EM_RD2(EM_rd2),.EM_ALU(EM_alu),.EM_Pc(EM_pc));
	// DM
	DM Dm(.MemWrite(M_MemWrite),.MemRead(M_MemRead),.Load_Type(M_Load_Type),.Store_Type(M_Store_Type),.SignRead(M_SignRead),
			.Clock(Clock),.Reset(Reset),
			.WPC(EM_pc),.Addr(EM_alu),.WD(tmux_em_rd2),
			.RD(md));
	
	
	
	// PIPE:module MW_PIPE(Clock,Reset,Enable,   M_IR,M_ALU,M_MD,M_Pc,   MW_IR,MW_ALU,MW_MD,MW_Pc);
	MW_PIPE MW_pipe(.Clock(Clock),.Reset(Reset),.Enable(1'b1),
						 .M_IR(EM_ir),.M_ALU(EM_alu),.M_MD(md),.M_Pc(EM_pc),
						 .MW_IR(MW_ir),.MW_ALU(MW_alu),.MW_MD(MW_md),.MW_Pc(MW_pc));
	
	
	
	// 数据通路：功能化多路选择器
	// MUX_AluSrc(AluSrc,DE_RD2,DE_EXT,DE_Pc4,AluB);
	MUX_AluSrc Mux_alusrc(.AluSrc(E_AluSrc),.DE_RD2(tmux_de_rd2),.DE_Ext(DE_ext),.DE_Pc4(DE_pc4),.AluB(muxalusrc));
	// module MUX_AluSel(AluSel,AluOut,HI,LO,Output);
	MUX_AluSel Mux_alusel(.AluSel(E_AluSel),.AluOut(aluout),.HI(hi),.LO(lo),.Output(muxalusel));
	// MUX_WaSel(WaSel,MW_IRRt,MW_IRRd,<$31>,WA);
	MUX_WaSel Mux_wasel(.WaSel(W_WaSel),.MW_IRRt(MW_ir[`rt]),.MW_IRRd(MW_ir[`rd]),.WA(muxwasel));
	// MUX_WdSel(WdSel,MW_ALU,MW_MD,WD);
	MUX_WdSel Mux_wdsel(.WdSel(W_WdSel),.MW_ALU(MW_alu),.MW_MD(MW_md),.WD(muxwdsel));
	
	// 数据通路：转发多路选择器
	// TMUX(Sel,Ori,EM_Alu,MW_Alu,MW_MD,Forward);
	TMUX TMux_GRF_RD1(.Sel(TMux_GRF_RD1_Sel),
							.Ori(rd1),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_grf_rd1));
							
	TMUX TMux_GRF_RD2(.Sel(TMux_GRF_RD2_Sel),
							.Ori(rd2),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_grf_rd2));
							
	TMUX TMux_DE_RD1(.Sel(TMux_DE_RD1_Sel),
							.Ori(DE_rd1),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_de_rd1));
							
	TMUX TMux_DE_RD2(.Sel(TMux_DE_RD2_Sel),
							.Ori(DE_rd2),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_de_rd2));
							
	TMUX TMux_EM_RD2(.Sel(TMux_EM_RD2_Sel),
							.Ori(EM_rd2),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_em_rd2));							

endmodule
