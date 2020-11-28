/*
version 7.2 2018.12.13 按照数据通路表格，新增input和output：input来源分别是（MCTRL和EXCCTRL），output去向是EXCCTRL，Bridge外部交互未添加
version 7.2 2018.12.13 按照数据通路表格，新增元器件：
version 7.2 2018.12.13 以每个datapath器件为中心，检查IO端口是否成功匹配
仅修改了datapath，通过了语法检查，模拟不存在连线名写错多定义问题。
-------------version 7.2 2018.12.13-----------------
version 7.3 2018.12.16 更改了eret的硬件清除指令位置，从D级变为E级，防止暂停和清除同时起效时将eret清除掉。
version 7.3 2018.12.16 HWClr指令从D级移动至E级。
version 7.3 2018.12.16 HWClr清除范围增加，除了D级流水线会被清除，其跳转功能也将失效（Branch、Jump_type,ERET），因此IF的跳转信号受到HWClr控制.
version 7.3 2018.12.16 修复了延迟槽判断逻辑，除了参考NPC输出，还需要参考跳转控制信号。
version 7.3 2018.12.16 修复了延迟槽判断逻辑，除了NPC输出、跳转控制信号以外，eret的硬件清除信号也需要纳入考虑。
version 7.5 2018.12.17 新增了bridge桥接模块，支持外部中断信号.(将cp0中断信号接入，将MW层寄存器的输入值进行选择来自bridge or dm)
version 7.5 2018.12.18 外移了bridge模块，增加了输入输出端口。
version 7.6 2018.12.19 在NPC中更新了延迟槽判断机制，分支无论跳转与否延迟槽均置1.
version 7.6 2018.12.19 新增在eret硬件清除的同时将pc值赋予为epc的行为（同时pc值对应指令的BD=0）,必须要这样做，否则将导致进入handler死循环状态。
version 8.0 2018.12.23 删除了XALU和AluSel模块，删除XALU和AluSel输出信号，删除XAluOp、Start、AluSel控制信号，删除Busy输出信号。
version 8.0 2018.12.23 外移了MDS模块至DM外部。
version 8.0 2018.12.24 引入了DM ip core，将Memwrite信号和MemRead信号分别承接给了BED和MDS模块。
version 8.0 2018.12.24 修正了DM-core的行为，其byteenable时寄存器值和dm值完全映射的，并不会取寄存器低位值处理。
version 8.1 2018.12.26 修复了BED模块WE信号的识别逻辑，当中断控制模块发出信号时，WE信号无效。
*/
`timescale 1ns / 1ps
`include "head.v"
module Datapath(Clock,Reset,Clock_2,
					 D_Branch_Jump,D_ExtOp,D_CmpOp,D_nPc_Sel,
					 // E_AluOp,E_XAluOp,E_Start,E_AluSrc,E_AluSel,E_HWClr,				// modified
					 E_AluOp,E_AluSrc,E_HWClr,				// modified
					 M_Store_Type,M_Load_Type,M_SignRead,M_MemRead,M_MemWrite,
					 M_CP0WE,M_ExlClr,					// new
					 W_WaSel,W_WdSel,W_RegWrite,
					 Stall,TMux_GRF_RD1_Sel,TMux_GRF_RD2_Sel,TMux_DE_RD1_Sel,TMux_DE_RD2_Sel,TMux_EM_RD2_Sel,
					 ExlSet,PPClr,WriteProtect,Handler,PcSel,ExcSel,				// new
					 
					 PrRd,HWInt,																// new
					 FD_IR,DE_IR,EM_IR,MW_IR,/*Busy,*/
					 CP0IntReq,M_ExcCode,M_BD,												// new	
					 PrWe,PrBE,PrAddr,PrWD);												// new														 
					 
	// clk and reset
	input Clock;
	input Reset;
	input Clock_2;
	// main controller signal
	input D_Branch_Jump;
	input D_ExtOp;
	input [`cmpop_size-1:0] D_CmpOp;
	input [`pcsel_size-1:0] D_nPc_Sel;
	input [`aluop_size-1:0] E_AluOp;
	// input [`xaluop_size-1:0] E_XAluOp;					
	// input [`start_size-1:0] E_Start;					
	input [`alusrc_size-1:0] E_AluSrc;
	// input [`alusel_size-1:0] E_AluSel;
	input E_HWClr;												// new	
	input [`store_type_size-1:0] M_Store_Type; 		
	input [`load_type_size-1:0] M_Load_Type;  		
	input M_SignRead;										
	input M_MemRead;
	input M_MemWrite;
	input M_ExlClr;											// new
	input M_CP0WE;												// new
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
	
	// exception controller signal
	input ExlSet;												// new
	input PPClr;												// new
	input WriteProtect;										// new
	input Handler;												// new
	input PcSel;												// new
	input ExcSel;												// new
	
	// outer data(bridge)
	input [31:0] PrRd;										// new
	input [7:2] HWInt;										// new
	
	// pipeline instructions
	output [31:0] FD_IR;
	output [31:0] DE_IR;
	output [31:0] EM_IR;
	output [31:0] MW_IR;
	// output Busy;
	output CP0IntReq;									// new
	output [`exc_size-1:0] M_ExcCode;									// new
	output M_BD;										// new
	
	output PrWe;										// new
	output [3:0] PrBE;								// new
	output [31:0] PrAddr;							// new
	output [31:0] PrWD;								// new
	
	// 每个功能器件为单位，定义其输出内容的网格线路(控制器和多路选择器单独于后面定义)
	// IFU
	wire [31:0] pc4;
	wire [31:0] ir;
	wire [31:0] pc;
	wire if_error;										// new
	// -------------FD_PIPE -------------
	wire [31:0] FD_ir;
	wire [31:0] FD_pc4;
	wire [31:0] FD_pc;
	wire FD_bd;											// new
	wire [`exc_size-1:0] FD_exccode;				// new
	// GRF
	wire [31:0] rd1;
	wire [31:0] rd2;
	// NPC
	wire [31:0] pc_update;
	wire slot_npc;										// new
	wire slot;											// new
	// EXT
	wire [31:0] ext;
	// CMP
	wire cmp;
	// IDU												// new
	wire [`irn_size-1:0] irn;
	wire [`irtype_size-1:0] irtype;
	wire idu_error;
	// CP0@D												// new
	wire [31:0] epc;
	// -------------DE_PIPE---------------
	wire [31:0] DE_ir;
	wire [31:0] DE_pc4;
	wire [31:0] DE_rd1;
	wire [31:0] DE_rd2;
	wire [31:0] DE_ext;
	wire [31:0] DE_pc;
	wire DE_bd;											// new
	wire [`exc_size-1:0] DE_exccode;				// new
	// ALU
	wire [31:0] aluout;
	wire alu_error;									// new
	// XALU	
	// wire [31:0] hi;										
	// wire [31:0] lo;										
	// wire busy;												
	// -------------EM_PIPE---------------
	wire [31:0] EM_ir;
	wire [31:0] EM_rd2;
	wire [31:0] EM_alu;
	wire [31:0] EM_pc;
	wire EM_bd;											// new
	wire [`exc_size-1:0]	EM_exccode;				// new
	// DM
	wire [31:0] md;
	wire [31:0] md_bridge;							// new
	// BED
	wire [3:0] byteenable;
	// MDS
	wire [31:0] datatoread;
	// MOV												// new
	wire mov_error;
	// CP0@M												// new
	wire intreq;
	wire [31:0] cp0_rd;
	// -------------MW_PIPE---------------
	wire [31:0] MW_ir;
	wire [31:0] MW_md;
	wire [31:0] MW_alu;
	wire [31:0] MW_pc;
	wire [31:0] MW_cp0;								// new
	
	// Function MUXs
	wire [31:0] muxalusrc;
	// wire [31:0] muxalusel;
	wire [4:0] muxwasel;
	wire [31:0] muxwdsel;
	wire [31:0] muxepc;								// new
	wire [`exc_size-1:0] muxexc;								// new
	
	// TRANSMIT MUXs
	wire [31:0] tmux_grf_rd1;
	wire [31:0] tmux_grf_rd2;
	wire [31:0] tmux_de_rd1;
	wire [31:0] tmux_de_rd2;
	wire [31:0] tmux_em_rd2;
	
	// ExcCode MUXs
	wire [`exc_size-1:0] emux_f;					// new
	wire [`exc_size-1:0] emux_d;					// new
	wire [`exc_size-1:0] emux_e;					// new
	wire [`exc_size-1:0] emux_m;					// new
	
	
	
	// CPU连线
	// 数据通路非部件逻辑定义 -- True Slot Detector
	assign slot = slot_npc & D_Branch_Jump & ~E_HWClr;	// new
	assign md_bridge = (EM_alu>=32'h0000&&EM_alu<=32'h2fff)?datatoread:PrRd; // new
	
	// 输出定义
	assign FD_IR = FD_ir;
	assign DE_IR = DE_ir;
	assign EM_IR = EM_ir;
	assign MW_IR = MW_ir;
	// assign Busy = busy;
	assign CP0IntReq = intreq;
	assign M_ExcCode = emux_m;
	assign M_BD = EM_bd;
	
	assign PrWe = M_MemWrite&&(~WriteProtect);			// new as follows
	assign PrBE = byteenable;
	assign PrAddr = EM_alu;
	assign PrWD = tmux_em_rd2;
	
	// 数据通路：主元件与流水线寄存器
	// module IF(Branch_Jump,Enable,Clock,Reset,Handler,PC_Update,PC4,Instr,PC,IF_Error);
	IF Ifu(.Branch_Jump(D_Branch_Jump&&(~E_HWClr)),.Enable(~Stall),.Clock(Clock),.Clock2(Clock_2),.Reset(Reset),.Handler(Handler),.PC_Update(pc_update),
							  .PC4(pc4),.Instr(ir),.PC(pc),.IF_Error(if_error));
	
	
	
	// PIPE:module FD_PIPE(Clock,Reset,Enable,  F_IR,F_Pc4,F_Pc,F_BD,F_ExcCode,  FD_IR,FD_Pc4,FD_Pc,FD_BD,FD_ExcCode);
	FD_PIPE FD_pipe(.Clock(Clock),.Reset(Reset|PPClr),.Enable(~Stall),
						 .F_IR(ir),.F_Pc4(pc4),.F_Pc(pc),
						 .F_BD(slot),.F_ExcCode(emux_f),
						 .FD_IR(FD_ir),.FD_Pc4(FD_pc4),.FD_Pc(FD_pc),
						 .FD_BD(FD_bd),.FD_ExcCode(FD_exccode));
	// GRF 
	GRF Grf(.RegWrite(W_RegWrite),.Clock(Clock),.Reset(Reset),
							.RA1(FD_ir[`rs]),.RA2(FD_ir[`rt]),
							.WA(muxwasel),.WD(muxwdsel),.WPC(MW_pc),
							.RD1(rd1),.RD2(rd2));
	// EXT(ExtOp, Input, Output);
	EXT Myext(.ExtOp(D_ExtOp),.Input(FD_ir[`im16]),.Output(ext));
	// CMP(CmpOp,A,B,Cmp);
	CMP Mycmp(.CmpOp(D_CmpOp),.A(tmux_grf_rd1),.B(tmux_grf_rd2),.Cmp(cmp));
	// NPC module NPC(Cmp,nPc_Sel,Im32,Im26,Pc4,RegPc,EPC,Pc_Update,Slot);
	NPC Npc(.Cmp(cmp),.nPc_Sel(D_nPc_Sel),.Im32(ext),.Im26(FD_ir[`im26]),.Pc4(FD_pc4),.RegPc(tmux_grf_rd1),.EPC(epc),
			  .Pc_Update(pc_update),.Slot(slot_npc));
	// IDU module IDU(IR,IRN,IRType,IDU_Error);
	IDU idu_D(.IR(FD_ir),.IRN(irn),.IRType(irtype),.IDU_Error(idu_error));
	
	
	
	// PIPE:module DE_PIPE(Clock,Reset,Enable,  D_IR,D_RD1,D_RD2,D_Ext,D_Pc4,D_Pc,D_BD,D_ExcCode,  DE_IR,DE_RD1,DE_RD2,DE_Ext,DE_Pc4,DE_Pc,DE_BD,DE_ExcCode);
	DE_PIPE DE_pipe(.Clock(Clock),.Reset(Reset|Stall|PPClr|E_HWClr),.Enable(1'b1),
						 .D_IR(FD_ir),.D_RD1(tmux_grf_rd1),.D_RD2(tmux_grf_rd2),.D_Ext(ext),.D_Pc4(FD_pc4),.D_Pc((E_HWClr)?epc:FD_pc),
						 .D_BD(FD_bd),.D_ExcCode(emux_d),
						 .DE_IR(DE_ir),.DE_RD1(DE_rd1),.DE_RD2(DE_rd2),.DE_Ext(DE_ext),.DE_Pc4(DE_pc4),.DE_Pc(DE_pc),
						 .DE_BD(DE_bd),.DE_ExcCode(DE_exccode));
	// ALU module ALU( AluOp,A,B,C, Result,Alu_Error);
	ALU Alu(.AluOp(E_AluOp),.A(tmux_de_rd1),.B(muxalusrc),.C(DE_ir[`s]),.Result(aluout),.Alu_Error(alu_error));
	/*// XALU module XALU(Clock,Reset,Start,Enable,XALUOp,Busy,RD1,RD2,HI,LO);
	XALU XAlu(.Clock(Clock),.Reset(Reset),.Start(E_Start),.Enable(~WriteProtect),.XALUOp(E_XAluOp),.Busy(busy),.RD1(tmux_de_rd1),.RD2(muxalusrc),
				 .HI(hi),.LO(lo));
	*/
	
	
	// PIPE:module EM_PIPE(Clock,Reset,Enable,E_IR,E_RD2,E_ALU,E_Pc,E_BD,E_ExcCode, EM_IR,EM_RD2,EM_ALU,EM_Pc,EM_BD,EM_ExcCode);
	EM_PIPE EM_pipe(.Clock(Clock),.Reset(Reset|PPClr),.Enable(1'b1),
					.E_IR(DE_ir),.E_RD2(tmux_de_rd2),.E_ALU(aluout),.E_Pc(DE_pc),
					.E_BD(DE_bd),.E_ExcCode(emux_e),
					.EM_IR(EM_ir),.EM_RD2(EM_rd2),.EM_ALU(EM_alu),.EM_Pc(EM_pc),
					.EM_BD(EM_bd),.EM_ExcCode(EM_exccode));
	// BED module BED(StoreType,Addr,MemWrite,ByteEnable);
	BED Bed(.StoreType(M_Store_Type),.MemWrite(M_MemWrite&(~WriteProtect)),.Addr(EM_alu[1:0]),.ByteEnable(byteenable));
	// DM + ip core
	DM dm (
		 .Clock1(Clock),
		 .Clock2(Clock_2), 
		 .Reset(Reset), 
		 .ByteEnable(byteenable), 
		 .WPC(EM_pc), 
		 .Addr(EM_alu), 
		 .WD(tmux_em_rd2), 
		 .RD(md)
	);
	// MDS module MDS(LoadType,SignRead,MemRead,Addr,Word,RD);
	MDS mds(.LoadType(M_Load_Type),.SignRead(M_SignRead),.MemRead(M_MemRead),.Addr(EM_alu[1:0]),.Word(md),.RD(datatoread));
	
	// MOV module MOV(IR,Addr,MOV_Error);
	MOV mov(.IR(EM_ir),.Addr(EM_alu),.MOV_Error(mov_error));
	// CP0 module CP0(Clock,Reset,WE,ExlSet,ExlClr,	RA,WA,WD,PC,ExcCode,BD, HWInt, IntReq,EPC,RD);
	CP0 cp0(.Clock(Clock),.Reset(Reset),.WE(M_CP0WE&&(~WriteProtect)),.ExlSet(ExlSet),.ExlClr(M_ExlClr),							
			  .RA(EM_ir[`rd]),.WA(EM_ir[`rd]),.WD(tmux_em_rd2),.PC(muxepc),.ExcCode(muxexc),.BD(EM_bd),
			  .HWInt(HWInt),
			  .IntReq(intreq),.EPC(epc),.RD(cp0_rd));
	
	
	// PIPE:module MW_PIPE(Clock,Reset,Enable,M_IR,M_ALU,M_MD,M_Pc,M_CP0, MW_IR,MW_ALU,MW_MD,MW_Pc,MW_CP0);
	MW_PIPE MW_pipe(.Clock(Clock),.Reset(Reset|PPClr),.Enable(1'b1),
						 .M_IR(EM_ir),.M_ALU(EM_alu),.M_MD(md_bridge),.M_Pc(EM_pc),
						 .M_CP0(cp0_rd),
						 .MW_IR(MW_ir),.MW_ALU(MW_alu),.MW_MD(MW_md),.MW_Pc(MW_pc),
						 .MW_CP0(MW_cp0));
	
	
	
	// 数据通路：功能化多路选择器
	// MUX_AluSrc(AluSrc,DE_RD2,DE_EXT,DE_Pc4,AluB);
	MUX_AluSrc Mux_alusrc(.AluSrc(E_AluSrc),.DE_RD2(tmux_de_rd2),.DE_Ext(DE_ext),.DE_Pc4(DE_pc4),.AluB(muxalusrc));
	// module MUX_AluSel(AluSel,AluOut,HI,LO,Output);
	// MUX_AluSel Mux_alusel(.AluSel(E_AluSel),.AluOut(aluout),.HI(hi),.LO(lo),.Output(muxalusel));
	// MUX_WaSel(WaSel,MW_IRRt,MW_IRRd,<$31>,WA);
	MUX_WaSel Mux_wasel(.WaSel(W_WaSel),.MW_IRRt(MW_ir[`rt]),.MW_IRRd(MW_ir[`rd]),.WA(muxwasel));
	// MUX_WdSel(WdSel,MW_ALU,MW_MD,MW_CP0,WD);
	MUX_WdSel Mux_wdsel(.WdSel(W_WdSel),.MW_ALU(MW_alu),.MW_MD(MW_md),.MW_CP0(MW_cp0),.WD(muxwdsel));
	// MUX_EPC(PcSel,Pc,Output);
	MUX_EPC Mux_epc(.PcSel(PcSel),.Pc(EM_pc),.Output(muxepc));
	// MUX_EXC(ExcSel,Exc,Output);
	MUX_EXC Mux_exc(.ExcSel(ExcSel),.Exc(emux_m),.Output(muxexc));
	
	// 数据通路：转发多路选择器
	// TMUX(Sel,Ori,EM_Alu,MW_Alu,MW_MD,MW_CP0,Forward);
	TMUX TMux_GRF_RD1(.Sel(TMux_GRF_RD1_Sel),
							.Ori(rd1),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.MW_CP0(MW_cp0),																// new
							.Forward(tmux_grf_rd1));
							
	TMUX TMux_GRF_RD2(.Sel(TMux_GRF_RD2_Sel),
							.Ori(rd2),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.MW_CP0(MW_cp0),																// new
							.Forward(tmux_grf_rd2));
							
	TMUX TMux_DE_RD1(.Sel(TMux_DE_RD1_Sel),
							.Ori(DE_rd1),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.MW_CP0(MW_cp0),																// new
							.Forward(tmux_de_rd1));
							
	TMUX TMux_DE_RD2(.Sel(TMux_DE_RD2_Sel),
							.Ori(DE_rd2),.EM_Alu(EM_alu),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.MW_CP0(MW_cp0),																// new
							.Forward(tmux_de_rd2));
							
	TMUX TMux_EM_RD2(.Sel(TMux_EM_RD2_Sel),
							.Ori(EM_rd2),.MW_Alu(MW_alu),.MW_MD(MW_md),
							.MW_CP0(MW_cp0),																// new
							.Forward(tmux_em_rd2));
	
	// 数据通路：内部异常信号收集选择器
	EMUX_F EMux_f(.IF_Error(if_error),.F_Exc(emux_f));
	EMUX_D EMux_d(.IDU_Error(idu_error),.FD_Exc(FD_exccode),.D_Exc(emux_d));
	EMUX_E EMux_e(.IR(DE_ir),.Alu_Error(alu_error),.DE_Exc(DE_exccode),.E_Exc(emux_e));
	EMUX_M EMux_m(.IR(EM_ir),.MOV_Error(mov_error),.EM_Exc(EM_exccode),.M_Exc(emux_m));

endmodule
