/*
1、连接端口时，务必注意要打上.，否则将会报错。
2、利用iSim模拟，可以进一步发现因为大小写而导致的“自动生成线”。
*/
`timescale 1ns / 1ps
`define op 31:26
`define func 5:0
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define s 10:6
`define im16 15:0
`define im26 25:0

`include "Main_Controller.v"
`include "IF.v"
`include "GRF.v"
`include "PCModule.v"
`include "EXT.v"
`include "ALU.v"
`include "DM.v"
`include "MUX_FUNC.v"
`include "PipeLineReg.v"
`include "HAZARD.v"

module mips_ori(clk,reset);
	input clk;
	input reset;
	
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
	
	// main controller
	wire D_branch_jump;
	wire D_extop;
	wire D_cmpop;
	wire [2:0] D_npc_sel;
	wire [3:0] E_aluop;
	wire [1:0] E_alusrc;
	wire M_memread;
	wire M_memwrite;																
	wire [1:0] W_wasel;
	wire [1:0] W_wdsel;
	wire W_regwrite;
	
	// Function MUXs
	wire [31:0] muxalusrc;
	wire [4:0] muxwasel;
	wire [31:0] muxwdsel;
	
	// Hazard Units
	// 由于目前不存在冲突控制模块，故以不暂停、无转发为默认状态为准。
	wire stall;
	wire [2:0] 	tmux_grf_rd1_sel;
	wire [2:0] 	tmux_grf_rd2_sel;
	wire [2:0]	tmux_de_rd1_sel;
	wire [2:0]  tmux_de_rd2_sel;
	wire [2:0]  tmux_em_rd2_sel;
	wire [31:0] tmux_grf_rd1;
	wire [31:0] tmux_grf_rd2;
	wire [31:0] tmux_de_rd1;
	wire [31:0] tmux_de_rd2;
	wire [31:0] tmux_em_rd2;
	
	
	// 流水线CPU连线
	// 控制逻辑
	// 指令流水，分别于D、E、M、W级别
	Main_Controller D_MCtrl(.Op(FD_ir[`op]),.Func(FD_ir[`func]),.Branch_Jump(D_branch_jump),.ExtOp(D_extop),.CmpOp(D_cmpop),.nPc_Sel(D_npc_sel)),
						 E_MCtrl(.Op(DE_ir[`op]),.Func(DE_ir[`func]),.AluSrc(E_alusrc),.AluOp(E_aluop)),
						 M_MCtrl(.Op(EM_ir[`op]),.Func(EM_ir[`func]),.MemRead(M_memread),.MemWrite(M_memwrite)),
						 W_MCtrl(.Op(MW_ir[`op]),.Func(MW_ir[`func]),.RegWrite(W_regwrite),.WaSel(W_wasel),.WdSel(W_wdsel));
	
	// 冒险-暂停指令控制器STALL(FD_IR,DE_IR,EM_IR,MW_IR,Stall);
	STALL Stall(.FD_IR(FD_ir),.DE_IR(DE_ir),.EM_IR(EM_ir),.MW_IR(MW_ir),.Stall(stall));
	
	// 冒险-转发指令控制器module TRANSMIT(FD_IR,DE_IR,EM_IR,MW_IR,TMux_GRF_RD1,TMux_GRF_RD2,TMux_DE_RD1,TMux_DE_RD2,TMux_EM_RD2);
	TRANSMIT Transmit(.FD_IR(FD_ir),.DE_IR(DE_ir),.EM_IR(EM_ir),.MW_IR(MW_ir),
					 .TMux_GRF_RD1(tmux_grf_rd1_sel),.TMux_GRF_RD2(tmux_grf_rd2_sel),
					 .TMux_DE_RD1(tmux_de_rd1_sel),.TMux_DE_RD2(tmux_de_rd2_sel),
					 .TMux_EM_RD2(tmux_em_rd2_sel));
	
	
	// 数据通路：主元件与流水线寄存器
	// module IF(Branch_Jump,Enable,Clock,Reset,PC_Update,PC4,Instr);
	IF Ifu(.Branch_Jump(D_branch_jump),.Enable(~stall),.Clock(clk),.Reset(reset),.PC_Update(pc_update),.PC4(pc4),.Instr(ir),.PC(pc));
	
	
	
	// PIPE:module FD_PIPE(Clock,Reset,Enable,   F_IR,F_Pc4,F_Pc,   FD_IR,FD_Pc4,FD_Pc);
	FD_PIPE FD_pipe(.Clock(clk),.Reset(reset),.Enable(~stall),
						 .F_IR(ir),.F_Pc4(pc4),.F_Pc(pc),
						 .FD_IR(FD_ir),.FD_Pc4(FD_pc4),.FD_Pc(FD_pc));
	// GRF 
	GRF Grf(.RegWrite(W_regwrite),.Clock(clk),.Reset(reset),
							.RA1(FD_ir[`rs]),.RA2(FD_ir[`rt]),
							.WA(muxwasel),.WD(muxwdsel),.WPC(MW_pc),
							.RD1(rd1),.RD2(rd2));
	// EXT(ExtOp, Input, Output);
	EXT Myext(.ExtOp(D_extop),.Input(FD_ir[`im16]),.Output(ext));
	// CMP(CmpOp,A,B,Cmp);
	CMP Mycmp(.CmpOp(D_cmpop),.A(tmux_grf_rd1),.B(tmux_grf_rd2),.Cmp(cmp));
	// NPC module NPC(Cmp,nPc_Sel,Im32,Im26,Pc4,RegPc,Pc_Update);
	NPC Npc(.Cmp(cmp),.nPc_Sel(D_npc_sel),.Im32(ext),.Im26(FD_ir[`im26]),.Pc4(FD_pc4),.RegPc(tmux_grf_rd1),.Pc_Update(pc_update));
	
	
	
	// PIPE:module DE_PIPE(Clock,Reset,Enable,    D_IR,D_RD1,D_RD2,D_Ext,D_Pc4,D_Pc,    DE_IR,DE_RD1,DE_RD2,DE_Ext,DE_Pc4,DE_Pc);
	DE_PIPE DE_pipe(.Clock(clk),.Reset(reset|stall),.Enable(1'b1),
						 .D_IR(FD_ir),.D_RD1(tmux_grf_rd1),.D_RD2(tmux_grf_rd2),.D_Ext(ext),.D_Pc4(FD_pc4),.D_Pc(FD_pc),
						 .DE_IR(DE_ir),.DE_RD1(DE_rd1),.DE_RD2(DE_rd2),.DE_Ext(DE_ext),.DE_Pc4(DE_pc4),.DE_Pc(DE_pc));
	// ALU
	ALU Alu(.AluOp(E_aluop),.A(tmux_de_rd1),.B(muxalusrc),.C(DE_ir[`s]),.Result(aluout));
	
	
	
	// PIPE:module EM_PIPE(Clock,Reset,Enable,   E_IR,E_RD2,E_ALU,E_Pc,   EM_IR,EM_RD2,EM_ALU,EM_Pc);
	EM_PIPE EM_pipe(.Clock(clk),.Reset(reset),.Enable(1'b1),
					.E_IR(DE_ir),.E_RD2(tmux_de_rd2),.E_ALU(aluout),.E_Pc(DE_pc),
					.EM_IR(EM_ir),.EM_RD2(EM_rd2),.EM_ALU(EM_alu),.EM_Pc(EM_pc));
	// DM
	DM Dm(.MemWrite(M_memwrite),.MemRead(M_memread),.Clock(clk),.Reset(reset),.WPC(EM_pc),.Addr(EM_alu),.WD(tmux_em_rd2),.RD(md));
	
	
	
	// PIPE:module MW_PIPE(Clock,Reset,Enable,   M_IR,M_ALU,M_MD,M_Pc,   MW_IR,MW_ALU,MW_MD,MW_Pc);
	MW_PIPE MW_pipe(.Clock(clk),.Reset(reset),.Enable(1'b1),
						 .M_IR(EM_ir),.M_ALU(EM_alu),.M_MD(md),.M_Pc(EM_pc),
						 .MW_IR(MW_ir),.MW_ALU(MW_alu),.MW_MD(MW_md),.MW_Pc(MW_pc));
	
	
	
	// 数据通路：功能化多路选择器
	// MUX_AluSrc(AluSrc,DE_RD2,DE_EXT,DE_Pc4,AluB);
	MUX_AluSrc Mux_alusrc(.AluSrc(E_alusrc),.DE_RD2(tmux_de_rd2),.DE_Ext(DE_ext),.DE_Pc4(DE_pc4),.AluB(muxalusrc));
	// MUX_WaSel(WaSel,MW_IRRt,MW_IRRd,<$31>,WA);
	MUX_WaSel Mux_wasel(.WaSel(W_wasel),.MW_IRRt(MW_ir[`rt]),.MW_IRRd(MW_ir[`rd]),.WA(muxwasel));
	// MUX_WdSel(WdSel,MW_ALU,MW_MD,WD);
	MUX_WdSel Mux_wdsel(.WdSel(W_wdsel),.MW_ALU(MW_alu),.MW_MD(MW_md),.WD(muxwdsel));
	
	// 数据通路：转发多路选择器
	// TMUX(Sel,Ori,EM_Alu,MW_Alu,MW_MD,Forward);
	TMUX TMux_GRF_RD1(.Sel(tmux_grf_rd1_sel),
							.Ori(rd1),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_grf_rd1));
							
	TMUX TMux_GRF_RD2(.Sel(tmux_grf_rd2_sel),
							.Ori(rd2),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_grf_rd2));
							
	TMUX TMux_DE_RD1(.Sel(tmux_de_rd1_sel),
							.Ori(DE_rd1),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_de_rd1));
							
	TMUX TMux_DE_RD2(.Sel(tmux_de_rd2_sel),
							.Ori(DE_rd2),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_de_rd2));
							
	TMUX TMux_EM_RD2(.Sel(tmux_em_rd2_sel),
							.Ori(EM_rd2),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.Forward(tmux_em_rd2));							

endmodule
