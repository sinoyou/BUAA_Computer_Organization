`timescale 1ns / 1ps
//`include "Control.v"
//`include "datapath.v"
`include "head.v"

module CPU(Clock,Reset,
			  PrRd,HWInt,
			  PrWe,PrBE,PrAddr,PrWd);
		input Clock;
		input Reset;
		
		input [31:0] PrRd;
		input [7:2] HWInt;
		output PrWe;
		output [3:0] PrBE;
		output [31:0] PrAddr;
		output [31:0] PrWd;
		
		
		// outputs of controllers
		// main ctrl
		wire D_branch_jump;
		wire D_extop;
		wire [`cmpop_size-1:0] D_cmpop;
		wire [`pcsel_size-1:0] D_npc_sel;
		wire [`aluop_size-1:0] E_aluop;
		wire [`xaluop_size-1:0] E_xaluop;			
		wire [`start_size-1:0] E_start;			
		wire [`alusrc_size-1:0] E_alusrc;			
		wire [`alusel_size-1:0] E_alusel;	
		wire E_hwclr;												// new		
		wire [`store_type_size-1:0] M_store_type; 
		wire [`load_type_size-1:0] M_load_type;	
		wire M_signread;										
		wire M_memread;
		wire M_memwrite;
		wire M_cp0we;												// new
		wire M_exlclr;												// new
		wire [`wasel_size-1:0] W_wasel;
		wire [`wdsel_size-1:0] W_wdsel;
		wire W_regwrite;
		
		// output of hazard
		wire stall;
		wire [`tmux_size-1:0] 	tmux_grf_rd1_sel;
		wire [`tmux_size-1:0] 	tmux_grf_rd2_sel;
		wire [`tmux_size-1:0]	tmux_de_rd1_sel;
		wire [`tmux_size-1:0]  tmux_de_rd2_sel;
		wire [`tmux_size-1:0]  tmux_em_rd2_sel;
		
		// outputs of ExcCtrl
		wire exlset;								 // new
		wire ppclr;									 // new
		wire writeprotect;						 // new
		wire handler;								 // new
		wire pcsel;									 // new
		wire excsel;								 // new
		
		// output of datapath
		wire [31:0] FD_ir;
		wire [31:0] DE_ir;
		wire [31:0] EM_ir;
		wire [31:0] MW_ir;
		wire busy;
		wire intreq;								// new
		wire [`exc_size-1:0] exccode;			// new
		wire bd;										// new
		
		
		// connect wires
		Control ctrl( 	 .FD_IR(FD_ir),.DE_IR(DE_ir),.EM_IR(EM_ir),.MW_IR(MW_ir),.Busy(busy),
							 .IntReq(intreq),.ExcCode(exccode),.BD(bd),								// new
							 .D_Branch_Jump(D_branch_jump),.D_ExtOp(D_extop),.D_CmpOp(D_cmpop),.D_nPc_Sel(D_npc_sel),
							 .E_AluOp(E_aluop),.E_XAluOp(E_xaluop),.E_Start(E_start),.E_AluSrc(E_alusrc),.E_AluSel(E_alusel),
							 .E_HWClr(E_hwclr),																// new
							 .M_Store_Type(M_store_type),.M_Load_Type(M_load_type),.M_SignRead(M_signread),.M_MemRead(M_memread),.M_MemWrite(M_memwrite),
							 .M_CP0WE(M_cp0we),.M_ExlClr(M_exlclr),									// new
							 .W_WaSel(W_wasel),.W_WdSel(W_wdsel),.W_RegWrite(W_regwrite),
							 .Stall(stall),
							 .TMux_GRF_RD1_Sel(tmux_grf_rd1_sel),
							 .TMux_GRF_RD2_Sel(tmux_grf_rd2_sel),
							 .TMux_DE_RD1_Sel(tmux_de_rd1_sel),
							 .TMux_DE_RD2_Sel(tmux_de_rd2_sel),
							 .TMux_EM_RD2_Sel(tmux_em_rd2_sel),
							 .ExlSet(exlset),.PPClr(ppclr),.WriteProtect(writeprotect),.Handler(handler),.ExcSel(excsel),.PcSel(pcsel)	// new
							 );
/*
module Control( FD_IR,DE_IR,EM_IR,MW_IR,Busy,
					 IntReq,ExcCode,BD,																// new
					 D_Branch_Jump,D_ExtOp,D_CmpOp,D_nPc_Sel,
					 D_HWClr,																			// new
					 E_AluOp,E_XAluOp,E_Start,E_AluSrc,E_AluSel,
					 M_Store_Type,M_Load_Type,M_SignRead,M_MemRead,M_MemWrite,
					 M_CP0WE,M_ExlClr,																// new
					 W_WaSel,W_WdSel,W_RegWrite,
					 Stall,TMux_GRF_RD1_Sel,TMux_GRF_RD2_Sel,TMux_DE_RD1_Sel,TMux_DE_RD2_Sel,TMux_EM_RD2_Sel,
					 ExlSet,PPClr,WriteProtect,Handler,ExcMux,PcMux							// new
					 );
*/
						 
		Datapath dp( 	 .Clock(Clock),.Reset(Reset),
							 .D_Branch_Jump(D_branch_jump),.D_ExtOp(D_extop),.D_CmpOp(D_cmpop),.D_nPc_Sel(D_npc_sel),
							 .E_AluOp(E_aluop),.E_XAluOp(E_xaluop),.E_Start(E_start),.E_AluSrc(E_alusrc),.E_AluSel(E_alusel),
							 .E_HWClr(E_hwclr),																		// new
							 .M_Store_Type(M_store_type),.M_Load_Type(M_load_type),.M_SignRead(M_signread),.M_MemRead(M_memread),.M_MemWrite(M_memwrite),
							 .M_CP0WE(M_cp0we),.M_ExlClr(M_exlclr),											// new
							 .W_WaSel(W_wasel),.W_WdSel(W_wdsel),.W_RegWrite(W_regwrite),
							 .Stall(stall),
							 .TMux_GRF_RD1_Sel(tmux_grf_rd1_sel),
							 .TMux_GRF_RD2_Sel(tmux_grf_rd2_sel),
							 .TMux_DE_RD1_Sel(tmux_de_rd1_sel),
							 .TMux_DE_RD2_Sel(tmux_de_rd2_sel),
							 .TMux_EM_RD2_Sel(tmux_em_rd2_sel),
							 .ExlSet(exlset),.PPClr(ppclr),.WriteProtect(writeprotect),.Handler(handler),.PcSel(pcsel),.ExcSel(excsel),		// new
							 .PrRd(PrRd),.HWInt(HWInt),							// new
							 .FD_IR(FD_ir),.DE_IR(DE_ir),.EM_IR(EM_ir),.MW_IR(MW_ir),.Busy(busy),
							 .CP0IntReq(intreq),.M_ExcCode(exccode),.M_BD(bd),							// new
							 .PrWe(PrWe),.PrBE(PrBE),.PrAddr(PrAddr),.PrWD(PrWd));															// new
				/*			 

module Datapath(Clock,Reset,
					 D_Branch_Jump,D_ExtOp,D_CmpOp,D_nPc_Sel,D_HWClr,				// modified
					 E_AluOp,E_XAluOp,E_Start,E_AluSrc,E_AluSel,
					 M_Store_Type,M_Load_Type,M_SignRead,M_MemRead,M_MemWrite,
					 M_CP0WE,M_ExlClr,					// new
					 W_WaSel,W_WdSel,W_RegWrite,
					 Stall,TMux_GRF_RD1_Sel,TMux_GRF_RD2_Sel,TMux_DE_RD1_Sel,TMux_DE_RD2_Sel,TMux_EM_RD2_Sel,
					 ExlSet,PPClr,WriteProtect,Handler,PcSel,ExcSel,				// new
					 FD_IR,DE_IR,EM_IR,MW_IR,Busy,
					 CP0IntReq,M_ExcCode,M_BD);											// new	
					 */

endmodule
