`timescale 1ns / 1ps
/*
0. MuxBranch(数据通路的控制信号): mux for select correct pc addr in branch-like instr. 
1. MuxRasel : mux for GRF write addr.
2. MuxAluSrc: mux for ALU B port operation number;
3. MuxPcSel: mux for pc update value;
4. MuxRdSel: mux for GRF write data.
*/
module MuxBranch(BranchJudge, Pc4, PcNew, Pc);
	input BranchJudge;
	input [31:0] Pc4, PcNew;
	output [31:0] Pc;
	assign Pc = (BranchJudge)? PcNew:Pc4;
endmodule

module MuxWaSel(WaSel,Rt,Rd,Wa);
	input [1:0] WaSel;
	input [4:0] Rt, Rd;
	output reg [4:0] Wa;
	
	always @(*)begin
		case(WaSel)
			0: Wa = Rt;								// rt
			1:	Wa = Rd;								// rd
			2:	Wa = 31;								// constant value 31 - $ra
			default: Wa = Rt;
		endcase
	end
endmodule


module MuxAluSrc(AluSrc,Rd2,Ext,Num);
	input AluSrc;
	input [31:0] Rd2, Ext;
	output [31:0] Num;
	
	assign Num = (AluSrc)? Ext:Rd2;
endmodule


module MuxPcSel(nPc_Sel,PcBranch,PcJ,PcJr,Pc);
	input [1:0] nPc_Sel;
	input [31:0] PcBranch,PcJ,PcJr;
	output reg [31:0] Pc;
	
	always @(*)begin
		case(nPc_Sel)
			0: Pc = PcBranch;							// beq decided pc addr
			1: Pc = PcJ;								// jump 
			2: Pc = PcJr;								// jr
			default: Pc = PcBranch;
		endcase
	end
endmodule


module MuxWdSel(WdSel, Alu, Mem,Pc4,Wd);
	input [1:0] WdSel;
	input [31:0] Alu, Mem, Pc4;
	output reg [31:0] Wd;
	
	always @(*)begin
		case(WdSel)
			0:Wd = Alu;
			1:Wd = Mem;									// lw
			2:Wd = Pc4;									// jr
			default: Wd = Alu;
		endcase
	end
endmodule
