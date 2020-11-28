/*
version 7.1 2018.12.12 新增RS输入端口，ExlClr、CP0WE、HWClr输出端口，增加对mfc0，mtc0，eret的支持
version 7.1 2018.12.13 修改了bug：补全了ExlClr、CP0WE、HWClr三个控制信号的输出；ExlClr信号应该由eret指令发出。
*/
`timescale 1ns / 1ps
`include "head.v"
`define pcsel_size 3
`define aluop_size 5
`define alusrc_size 2
`define wasel_size 2
`define wdsel_size 2
`define tmux_size 3
`define cmpop_size 3
`define xaluop_size 3
`define alusel_size 2
`define start_size 2
`define xaluop_size 3
`define store_type_size 2
`define load_type_size 2

module Main_Controller(Op,Func,Rt,Rs,							// new
							  Branch_Jump,nPc_Sel,AluSrc,MemRead,MemWrite,RegWrite,WaSel,WdSel,
							  ExlClr,CP0WE,HWClr,					// new
							  ExtOp,CmpOp,AluOp,AluSel,Start,XAluOp,Store_Type,Load_Type,Sign_Read);
	input [5:0] Op;
	input [5:0] Func;
	input [4:0] Rt;
	input [4:0] Rs;
	// begin for general ctrl signals
	output Branch_Jump;
	output [`pcsel_size-1:0] nPc_Sel;
	output [`alusrc_size-1:0] AluSrc;
	output MemRead;
	output MemWrite;
	output RegWrite;
	output [`wasel_size-1:0] WaSel;
	output [`wdsel_size-1:0] WdSel;
		// new
	output ExlClr;
	output CP0WE;
	output HWClr;
	// begin for special ctrl signals
	output ExtOp;
	output [`cmpop_size-1:0] CmpOp;
	output [`aluop_size-1:0] AluOp;
	output [`alusel_size-1:0] AluSel;
	output [`start_size-1:0] Start;
	output [`xaluop_size-1:0] XAluOp;
	output [`store_type_size-1:0] Store_Type;
	output [`load_type_size-1:0] Load_Type;
	output Sign_Read;
	
	// single instructions 
	wire add,addu,sub,subu,
		  sll,srl,sra,sllv,srlv,srav,
		  _and,_or,_xor,_nor,
		  slt,sltu,
		  mult,multu,div,divu,
		  mthi,mtlo,mfhi,mflo;
	wire addi,addiu,
		  andi,ori,xori,
		  lui,
		  slti,sltiu;
	wire lw,
		  lb,lbu,
		  lh,lhu;
	wire sw,sh,sb;
	wire beq,bne,blez,bgtz,bltz,bgez;
	wire j,jal,jr,jalr;
	wire mfc0,mtc0,eret;
	
	// type instructions 
	wire calr,cali,ld,st,branch; // + j, jal, jr, jalr
	
	// begin for general ctrl signals
	assign Branch_Jump = j|jal|jr|jalr|branch|eret;
	assign nPc_Sel = (branch)?0:
						  (j|jal)?1:
						  (jr|jalr)?2:
						  (eret)?3:0;
	assign AluSrc = (calr)?0:
						 (cali|ld|st)?1:
						 (jal|jalr)?2:0;
	assign MemRead = (ld)?1:0;
	assign MemWrite = (st)?1:0;
	assign RegWrite = (calr|cali|ld|jal|jalr|mfc0)?1:0;
	assign WaSel = (cali|ld|mfc0)?0:
						(calr|jalr)?1:
						(jal)?2:0;
	assign WdSel = (calr|cali|jal|jalr)?0:
						(ld)?1:
						(mfc0)?2:0;
		// new added
	assign ExlClr = (eret)?1:0;
	assign CP0WE = (mtc0)?1:0;
	assign HWClr = (eret)?1:0;
	
						
	// begin for special strl signals
	assign ExtOp = (andi|ori|xori|lui)?0:
						(addi|addiu|slti|sltiu|ld|st|branch)?1:0;
	assign CmpOp = beq?0:
						bne?1:
						blez?2:
						bgtz?3:
						bltz?4:
						bgez?5:0;
	assign AluOp = (add|addu|addi|addiu|ld|st)?0:
						(sub|subu)?1:
						(sll)?2:
						(srl)?3:
						(sra)?4:
						(sllv)?5:
						(srlv)?6:
						(srav)?7:
						(_and|andi)?8:
						(_or|ori)?9:
						(_xor|xori)?10:
						(_nor)?11:
						(slt|slti)?12:
						(sltu|sltiu)?13:
						(lui)?14:
						(jal|jalr)?15:0;
	assign AluSel = (mfhi)?1:
						 (mflo)?2:0;
	assign Start = (mult|multu|div|divu)?1:
						(mthi|mtlo)?2:0;
	assign XAluOp = mult?0:
						 multu?1:
						 div?2:
						 divu?3:
						 mthi?4:
						 mtlo?5:0;
	assign Store_Type = sw?0:
							  sh?1:
							  sb?2:0;
	assign Load_Type = (lw)?0:
							 (lh|lhu)?1:
							 (lb|lbu)?2:0;
	assign Sign_Read = (lb|lh)?1:
							 (lbu|lhu)?0:0;
	
	
	// begin for type instructions recognized
	assign calr = add|addu|sub|subu|
					  sll|srl|sra|sllv|srlv|srav|
					  _and|_or|_xor|_nor|
					  slt|sltu|
					  mult|multu|div|divu|
					  mthi|mtlo|mfhi|mflo;
	assign cali = addi|addiu|
					  andi|ori|xori|
					  lui|
					  slti|sltiu;
	assign ld = lw|lb|lbu|lh|lhu;
	assign st = sw|sh|sb;
	assign branch = beq|bne|blez|bgtz|bltz|bgez;
	// j jal jr jalr
	
	// begin for single instruction recognized
	// calr
	assign add = (Op==6'b000000 && Func==6'b100000);
	assign addu = (Op==6'b000000 && Func==6'b100001);
	assign sub = (Op==6'b000000 && Func==6'b100010);
	assign subu = (Op==6'b000000 && Func==6'b100011);
	assign sll = (Op==6'b000000 && Func==6'b000000);
	assign srl = (Op==6'b000000 && Func==6'b000010);
	assign sra = (Op==6'b000000 && Func==6'b000011);
	assign sllv = (Op==6'b000000 && Func==6'b000100);
	assign srlv = (Op==6'b000000 && Func==6'b000110);
	assign srav = (Op==6'b000000 && Func==6'b000111);
	assign _and = (Op==6'b000000 && Func==6'b100100);
	assign _or = (Op==6'b000000 && Func==6'b100101);
	assign _xor = (Op==6'b000000 && Func==6'b100110);
	assign _nor = (Op==6'b000000 && Func==6'b100111);
	assign slt = (Op==6'b000000 && Func==6'b101010);
	assign sltu = (Op==6'b000000 && Func==6'b101011);
	assign mult = (Op==6'b000000 && Func==6'b011000);
	assign multu = (Op==6'b000000 && Func==6'b011001);
	assign div = (Op==6'b000000 && Func==6'b011010);
	assign divu = (Op==6'b000000 && Func==6'b011011);
	assign mthi = (Op==6'b000000 && Func==6'b010001);
	assign mtlo = (Op==6'b000000 && Func==6'b010011);
	assign mfhi = (Op==6'b000000 && Func==6'b010000);
	assign mflo = (Op==6'b000000 && Func==6'b010010);
	// cali
	assign addi = (Op==6'b001000);
	assign addiu = (Op==6'b001001);
	assign andi = (Op==6'b001100);
	assign ori = (Op==6'b001101);
	assign xori = (Op==6'b001110);
	assign lui = (Op==6'b001111);
	assign slti = (Op==6'b001010);
	assign sltiu = (Op==6'b001011);
	// ld
	assign lw = (Op==6'b100011);
	assign lb = (Op==6'b100000);
	assign lbu = (Op==6'b100100);
	assign lh = (Op==6'b100001);
	assign lhu = (Op==6'b100101);
	// st
	assign sw = (Op==6'b101011);
	assign sh = (Op==6'b101001);
	assign sb = (Op==6'b101000);
	// b_type
	assign beq = (Op==6'b000100);
	assign bne = (Op==6'b000101);
	assign blez = (Op==6'b000110);
	assign bgtz = (Op==6'b000111);
	assign bltz = (Op==6'b000001 && Rt==5'b00000);
	assign bgez = (Op==6'b000001 && Rt==5'b00001);
	// j type
	assign j = (Op==6'b000010);
	assign jal = (Op==6'b000011);
	assign jr = (Op==6'b000000 && Func==6'b001000);
	assign jalr = (Op==6'b000000 && Func==6'b001001);
	// cp0 instr
	assign mfc0 = (Op==6'b010000 && Rs==5'b00000);
	assign mtc0 = (Op==6'b010000 && Rs==5'b00100);
	assign eret = (Op==6'b010000 && Func==6'b011000);
	
endmodule

/*module Main_Controller(Op,Func,
		Branch_Jump,RegWrite,ExtOp,nPc_Sel,AluOp,MemRead,MemWrite,CmpOp,
		AluSrc,WaSel,WdSel);
		input [5:0] Op;
		input [5:0] Func;
		output Branch_Jump;
		output RegWrite;
		output ExtOp;
		output [`pcsel_size-1:0] nPc_Sel;
		output [`aluop_size-1:0] AluOp;
		output MemRead;
		output MemWrite;
		output [`cmpop_size-1:0] CmpOp;
		output [`alusrc_size-1:0] AluSrc;
		output [`wasel_size-1:0] WaSel;
		output [`wdsel_size-1:0] WdSel;
		
		 
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
							
		assign WdSel = (addu|subu|sll|ori|lui|jal)?0:
							(lw)?1:
							0;
endmodule
*/