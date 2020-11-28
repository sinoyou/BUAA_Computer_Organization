`timescale 1ns / 1ps
/*
1、多位控制指令，使用reg型变量，单位的用wire型（assign赋值）。
2、先锁定指令类型，再分配控制信号.
3、比较时一定要写上字符的类型（例如二进制）
*/
// {addu, subu, ori, lw, sw, beq, lui, jal, jr,sll(nop) }
module Controller(Op,Function,RegWrite,MemRead,MemWrite,Branch_Jump,WaSel,WdSel,ExtOp,AluSrc,AluOp,nPc_Sel);
    input [5:0] Op;
    input [5:0] Function;
    output RegWrite;
    output MemRead;
    output MemWrite;
    output Branch_Jump;
    output reg [1:0] WaSel;
    output reg [1:0] WdSel;
    output ExtOp;
    output AluSrc;
    output reg [3:0] AluOp;
    output reg [1:0] nPc_Sel;
	 
	 wire addu, subu, jr, sll, ori, lw, sw, beq, lui, jal;
	 
	 // 指令识别
	 assign addu = (Op == 6'b000000 && Function == 6'b100001)? 1 : 0;
	 assign subu = (Op == 6'b000000 && Function == 6'b100011)? 1 : 0;
	 assign jr = (Op == 6'b000000 && Function == 6'b001000)? 1 : 0;
	 assign sll = (Op == 6'b000000 && Function == 6'b000000)? 1 : 0;
	 assign ori = (Op == 6'b001101)? 1 : 0;
	 assign lw = (Op == 6'b100011)? 1 : 0;
	 assign sw = (Op == 6'b101011)? 1 : 0;
	 assign beq = (Op == 6'b000100)? 1 : 0;
	 assign lui = (Op == 6'b001111)? 1 : 0;
	 assign jal = (Op == 6'b000011)? 1 : 0;
	 
	 // 控制信号分发窗口
	 assign RegWrite = addu | subu | sll | ori | lw | lui | jal;
	 assign MemRead = lw;
	 assign MemWrite = sw;
	 assign Branch_Jump = jr | beq | jal;
	 assign ExtOp = lw | sw | beq;
	 assign AluSrc = ori | lui | lw | sw;
	 
	 always @(*)begin
		if(addu | subu | sll) WaSel = 1;
		else if (jal) WaSel = 2;
		else WaSel = 0;
	 end
	 
	 always @(*)begin
		if(lw) WdSel = 1;
		else if(jal) WdSel = 2;
		else WdSel = 0;
	 end
	 
	 always @(*)begin
		if(addu|lw|sw)AluOp = 0;
		else if(subu)AluOp = 1;
		else if(ori)AluOp = 2;
		else if(beq)AluOp = 3;
		else if(lui)AluOp = 4;
		else if(jr)AluOp = 5;
		else if(sll)AluOp = 6;
		else AluOp = 0;
	 end
	 
	 always @(*)begin
		if(jal)nPc_Sel = 1;
		else if(jr)nPc_Sel = 2;
		else nPc_Sel = 0;
	 end

endmodule
