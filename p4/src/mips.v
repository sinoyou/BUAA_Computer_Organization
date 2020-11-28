`timescale 1ns / 1ps
`include "IF.v"
`include "GRF.v"
`include "ALU.v"
`include "DM.v"
`include "EXT.v"
`include "PcModule.v"
`include "MUX.v"
`include "Controller.v"

module mips(
    input reset,
    input clk
    );
	 // 以每个元件为单位，定义其输出内容
	 // IF
	 wire [31:0] pc;
	 wire [31:0] instr;
	 wire [31:0] pc4;
	 // IF adding
	 wire [5:0] op;
	 wire [4:0] rs;
	 wire [4:0] rt;
	 wire [4:0] rd;
	 wire [4:0] s;
	 wire [5:0] func;
	 wire [15:0] im16;
	 wire [25:0] im26;
	 wire [3:0] pchead;
	 // GRF
	 wire [31:0] regdata1;
	 wire [31:0] regdata2;
	 // ALU
	 wire [31:0] aluout;
	 // DM
	 wire [31:0] dmout;
	 // Ext
	 wire [31:0] ext32;
	 // Jump
	 wire [31:0] pcjump;
	 // Nadd
	 wire [31:0] pcbranched;			// 注意不是最终的branch值，还要根据比较情况决定
	 
	 // controller
	 wire regwrite;
	 wire memread;
	 wire memwrite;
	 wire branch_jump;
	 wire [1:0] wasel;
	 wire [1:0] wdsel;
	 wire extop;
	 wire alusrc;
	 wire [3:0] aluop;
	 wire [1:0] npc_sel;
	 
	 // multiplexer
	 wire [31:0] muxbranch;
	 wire [4:0] muxwasel;
	 wire [31:0] muxalusrc;
	 wire [31:0] muxpcsel;
	 wire [31:0] muxwdsel;
	 
	 
	 // IF预连线
	 assign pc4 = pc+4;
	 assign op[5:0] = instr[31:26];
	 assign rs[4:0] = instr[25:21];
	 assign rt[4:0] = instr[20:16];
	 assign rd[4:0] = instr[15:11];
	 assign s[4:0] = instr[10:6];
	 assign func[5:0] = instr[5:0];
	 assign im16[15:0] = instr[15:0];
	 assign im26[25:0] = instr[25:0];
	 assign pchead[3:0] = instr[31:28];
	 
	 
	 // 以每个元件为单元，实例化+指定其IO端口
	 // controller
	 Controller controller(.Op(op),.Function(func),.RegWrite(regwrite),.MemRead(memread),.MemWrite(memwrite),
								  .Branch_Jump(branch_jump),.WaSel(wasel),.WdSel(wdsel),.ExtOp(extop),.AluSrc(alusrc),
								  .AluOp(aluop),.nPc_Sel(npc_sel));
	 // IF
	 IF instr_file(.Branch_Jump(branch_jump),.Clock(clk),.Reset(reset),.PC_Update(muxpcsel),.PC(pc),.Instr(instr));
	 // GRF
	 GRF grf(.RegWrite(regwrite),.Clock(clk),.Reset(reset),.RA1(rs),.RA2(rt),.WA(muxwasel),.WD(muxwdsel),.WPC(pc),
				.RD1(regdata1),.RD2(regdata2));
	 // ALU
	 ALU alu(.AluOp(aluop),.A(regdata1),.B(muxalusrc),.C(s),.Result(aluout));
	 // DM
	 DM dm(.MemWrite(memwrite),.MemRead(memread),.Clock(clk),.Reset(reset),.WPC(pc),.Addr(aluout),.WD(regdata2),.RD(dmout));
	 // ExtOp
	 EXT ext(.ExtOp(extop),.Input(im16),.Output(ext32));
	 // Nadd
	 Nadd nadd(.Pc4(pc4),.Im(ext32),.Out(pcbranched));
	 // Jump
	 Jump jump(.JIm(im26),.PCHead(pchead),.JumpPC(pcjump));
	 // MuxBranch(BranchJudge, Pc4, PcNew, Pc)
	 MuxBranch mymuxbranch(.BranchJudge(aluout), .Pc4(pc4), .PcNew(pcbranched), .Pc(muxbranch));
	 // MuxWaSel(WaSel,Rt,Rd,Wa);
	 MuxWaSel mymuxwasel(.WaSel(wasel),.Rt(rt),.Rd(rd),.Wa(muxwasel));
	 // MuxAluSrc(AluSrc,Rd2,Ext,Num);
	 MuxAluSrc mymuxalusrc(.AluSrc(alusrc),.Rd2(regdata2),.Ext(ext32),.Num(muxalusrc));
	 // MuxPcSel(nPc_Sel,PcBranch,PcJ,PcJr,Pc);
	 MuxPcSel mymuxpcsel(.nPc_Sel(npc_sel),.PcBranch(muxbranch),.PcJ(pcjump),.PcJr(aluout),.Pc(muxpcsel));
	 // module MuxWdSel(WdSel, Alu, Mem,Pc4,Wd);
	 MuxWdSel mymuxwdsel(.WdSel(wdsel), .Alu(aluout), .Mem(dmout), .Pc4(pc4), .Wd(muxwdsel));

endmodule
