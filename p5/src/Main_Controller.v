`timescale 1ns / 1ps
module Main_Controller(Op,Func,
		Branch_Jump,RegWrite,ExtOp,nPc_Sel,AluOp,MemRead,MemWrite,CmpOp,
		AluSrc,WaSel,WdSel);
		input [5:0] Op;
		input [5:0] Func;
		output Branch_Jump;
		output RegWrite;
		output ExtOp;
		output [2:0] nPc_Sel;
		output [3:0] AluOp;
		output MemRead;
		output MemWrite;
		output CmpOp;
		output [1:0] AluSrc;
		output [1:0] WaSel;
		output [1:0] WdSel;
		
		 
		// 指令识别
		wire addu, subu, jr, sll, ori, lw, sw, beq, lui, jal;
		assign addu  = (Op == 6'b000000 && Func == 6'b100001)? 1 : 0;
		assign subu  = (Op == 6'b000000 && Func == 6'b100011)? 1 : 0;
		assign jr  = (Op == 6'b000000 && Func == 6'b001000)? 1 : 0;
		assign sll  = (Op == 6'b000000 && Func == 6'b000000)? 1 : 0;
		assign ori = (Op == 6'b001101)? 1 : 0;
		assign lw = (Op == 6'b100011)? 1 : 0;
		assign sw = (Op == 6'b101011)? 1 : 0;
		assign beq = (Op == 6'b000100)? 1 : 0;
		assign lui = (Op == 6'b001111)? 1 : 0;
		assign jal = (Op == 6'b000011)? 1 : 0;
		assign j = (Op == 6'b000010)? 1 : 0;
		 
		// 控制信号生成
		assign Branch_Jump = beq | j | jal | jr;
		assign RegWrite = addu | subu | sll | ori | lw | lui | jal;
		assign ExtOp = lw | sw | beq;
		
		assign nPc_Sel = (beq)?0:
							  (j|jal)?1:
							  (jr)?2:
									 0;
									 
		assign AluOp = (addu|lw|sw)?0:
							(subu)?1:
							(sll)?2:
							(ori)?3:
							(lui)?4:
							(jal)?5:
									0;
									
		assign MemRead = lw;
		assign MemWrite = sw;
		
		assign CmpOp = (beq)?0:0;
		
		assign AluSrc = (addu|subu|sll)?0:
							 (ori|lui|lw|sw)?1:
							 (jal)?2:
							 0;
							 
		assign WaSel = (addu|subu|sll)?1:
							(ori|lui|lw)?0:
							(jal)?2:
							0;
							
		assign WdSel = (addu|subu|sll|ori|lui)?0:
							(lw)?1:
							0;
endmodule
