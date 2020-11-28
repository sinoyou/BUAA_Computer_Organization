/*
version 7.2 2018.12.13 ��������ͨ·�������input��output��input��Դ�ֱ��ǣ�MCTRL��EXCCTRL����outputȥ����EXCCTRL��Bridge�ⲿ����δ���
version 7.2 2018.12.13 ��������ͨ·�������Ԫ������
version 7.2 2018.12.13 ��ÿ��datapath����Ϊ���ģ����IO�˿��Ƿ�ɹ�ƥ��
���޸���datapath��ͨ�����﷨��飬ģ�ⲻ����������д��ඨ�����⡣
-------------version 7.2 2018.12.13-----------------
version 7.3 2018.12.16 ������eret��Ӳ�����ָ��λ�ã���D����ΪE������ֹ��ͣ�����ͬʱ��Чʱ��eret�������
version 7.3 2018.12.16 HWClrָ���D���ƶ���E����
version 7.3 2018.12.16 HWClr�����Χ���ӣ�����D����ˮ�߻ᱻ���������ת����Ҳ��ʧЧ��Branch��Jump_type,ERET�������IF����ת�ź��ܵ�HWClr����.
version 7.3 2018.12.16 �޸����ӳٲ��ж��߼������˲ο�NPC���������Ҫ�ο���ת�����źš�
version 7.3 2018.12.16 �޸����ӳٲ��ж��߼�������NPC�������ת�����ź����⣬eret��Ӳ������ź�Ҳ��Ҫ���뿼�ǡ�
version 7.5 2018.12.17 ������bridge�Ž�ģ�飬֧���ⲿ�ж��ź�.(��cp0�ж��źŽ��룬��MW��Ĵ���������ֵ����ѡ������bridge or dm)
version 7.5 2018.12.18 ������bridgeģ�飬��������������˿ڡ�
version 7.6 2018.12.19 ��NPC�и������ӳٲ��жϻ��ƣ���֧������ת����ӳٲ۾���1.
version 7.6 2018.12.19 ������eretӲ�������ͬʱ��pcֵ����Ϊepc����Ϊ��ͬʱpcֵ��Ӧָ���BD=0��,����Ҫ�����������򽫵��½���handler��ѭ��״̬��
version 8.0 2018.12.23 ɾ����XALU��AluSelģ�飬ɾ��XALU��AluSel����źţ�ɾ��XAluOp��Start��AluSel�����źţ�ɾ��Busy����źš�
version 8.0 2018.12.23 ������MDSģ����DM�ⲿ��
version 8.0 2018.12.24 ������DM ip core����Memwrite�źź�MemRead�źŷֱ�нӸ���BED��MDSģ�顣
version 8.0 2018.12.24 ������DM-core����Ϊ����byteenableʱ�Ĵ���ֵ��dmֵ��ȫӳ��ģ�������ȡ�Ĵ�����λֵ����
version 8.1 2018.12.26 �޸���BEDģ��WE�źŵ�ʶ���߼������жϿ���ģ�鷢���ź�ʱ��WE�ź���Ч��
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
	
	// ÿ����������Ϊ��λ��������������ݵ�������·(�������Ͷ�·ѡ���������ں��涨��)
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
	
	
	
	// CPU����
	// ����ͨ·�ǲ����߼����� -- True Slot Detector
	assign slot = slot_npc & D_Branch_Jump & ~E_HWClr;	// new
	assign md_bridge = (EM_alu>=32'h0000&&EM_alu<=32'h2fff)?datatoread:PrRd; // new
	
	// �������
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
	
	// ����ͨ·����Ԫ������ˮ�߼Ĵ���
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
	
	
	
	// ����ͨ·�����ܻ���·ѡ����
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
	
	// ����ͨ·��ת����·ѡ����
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
	
	// ����ͨ·���ڲ��쳣�ź��ռ�ѡ����
	EMUX_F EMux_f(.IF_Error(if_error),.F_Exc(emux_f));
	EMUX_D EMux_d(.IDU_Error(idu_error),.FD_Exc(FD_exccode),.D_Exc(emux_d));
	EMUX_E EMux_e(.IR(DE_ir),.Alu_Error(alu_error),.DE_Exc(DE_exccode),.E_Exc(emux_e));
	EMUX_M EMux_m(.IR(EM_ir),.MOV_Error(mov_error),.EM_Exc(EM_exccode),.M_Exc(emux_m));

endmodule
