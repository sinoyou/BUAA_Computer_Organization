`timescale 1ns / 1ps
`include "Control.v"
`include "datapath.v"
`include "head.v"

module mips(clk,reset);
		input clk;
		input reset;
		
		// outputs of controllers
		// main ctrl
		wire D_branch_jump;
		wire D_extop;
		wire [`cmpop_size-1:0] D_cmpop;
		wire [`pcsel_size-1:0] D_npc_sel;
		wire [`aluop_size-1:0] E_aluop;
		wire [`xaluop_size-1:0] E_xaluop;			// new
		wire [`start_size-1:0] E_start;				// new
		wire [`alusrc_size-1:0] E_alusrc;			
		wire [`alusel_size-1:0] E_alusel;			// new
		wire [`store_type_size-1:0] M_store_type; // new
		wire [`load_type_size-1:0] M_load_type;	// new
		wire M_signread;										// new
		wire M_memread;
		wire M_memwrite;																
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
		
		// output of datapath
		wire [31:0] FD_ir;
		wire [31:0] DE_ir;
		wire [31:0] EM_ir;
		wire [31:0] MW_ir;
		wire busy;
		
		
		// connect wires
		Control ctrl( 	 .FD_IR(FD_ir),.DE_IR(DE_ir),.EM_IR(EM_ir),.MW_IR(MW_ir),.Busy(busy),
							 .D_Branch_Jump(D_branch_jump),.D_ExtOp(D_extop),.D_CmpOp(D_cmpop),.D_nPc_Sel(D_npc_sel),
							 .E_AluOp(E_aluop),.E_XAluOp(E_xaluop),.E_Start(E_start),.E_AluSrc(E_alusrc),.E_AluSel(E_alusel),
							 .M_Store_Type(M_store_type),.M_Load_Type(M_load_type),.M_SignRead(M_signread),.M_MemRead(M_memread),.M_MemWrite(M_memwrite),
							 .W_WaSel(W_wasel),.W_WdSel(W_wdsel),.W_RegWrite(W_regwrite),
							 .Stall(stall),
							 .TMux_GRF_RD1_Sel(tmux_grf_rd1_sel),
							 .TMux_GRF_RD2_Sel(tmux_grf_rd2_sel),
							 .TMux_DE_RD1_Sel(tmux_de_rd1_sel),
							 .TMux_DE_RD2_Sel(tmux_de_rd2_sel),
							 .TMux_EM_RD2_Sel(tmux_em_rd2_sel));
						 
		Datapath dp( 	 .Clock(clk),.Reset(reset),
							 .D_Branch_Jump(D_branch_jump),.D_ExtOp(D_extop),.D_CmpOp(D_cmpop),.D_nPc_Sel(D_npc_sel),
							 .E_AluOp(E_aluop),.E_XAluOp(E_xaluop),.E_Start(E_start),.E_AluSrc(E_alusrc),.E_AluSel(E_alusel),
							 .M_Store_Type(M_store_type),.M_Load_Type(M_load_type),.M_SignRead(M_signread),.M_MemRead(M_memread),.M_MemWrite(M_memwrite),
							 .W_WaSel(W_wasel),.W_WdSel(W_wdsel),.W_RegWrite(W_regwrite),
							 .Stall(stall),
							 .TMux_GRF_RD1_Sel(tmux_grf_rd1_sel),
							 .TMux_GRF_RD2_Sel(tmux_grf_rd2_sel),
							 .TMux_DE_RD1_Sel(tmux_de_rd1_sel),
							 .TMux_DE_RD2_Sel(tmux_de_rd2_sel),
							 .TMux_EM_RD2_Sel(tmux_em_rd2_sel),
							 .FD_IR(FD_ir),.DE_IR(DE_ir),.EM_IR(EM_ir),.MW_IR(MW_ir),.Busy(busy));

endmodule
