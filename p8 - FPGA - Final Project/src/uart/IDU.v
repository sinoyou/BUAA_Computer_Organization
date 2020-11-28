/*
version 8.0 2018.12.23 删除了对mult，div，multu，divu，mthi，mtlo，mfhi，mflo指令的识别。 
*/
`timescale 1ns / 1ps
`include "head.v"
`include "instr_list.v"
module IDU(IR,IRN,IRType,IDU_Error);
		input [31:0] IR;
		output [`irn_size-1:0] IRN; 
		output [`irtype_size-1:0] IRType;
		output IDU_Error;
		
		assign IDU_Error = (IRN==0)?1:0;
		
		wire [5:0] Op, Func;
		wire [4:0] Rs,Rt;
		
		// group instruction recoginzed
		assign IRType = (IRN>=`add&&IRN<=`mflo)?`calr:
							 (IRN>=`addi&&IRN<=`sltiu)?`cali:
							 (IRN>=`lw&&IRN<=`lhu)?`ld:
							 (IRN>=`st&&IRN<=`sb)?`st:
							 (IRN>=`beq&&IRN<=`bgez)?`branch:
							 (IRN==`j)?`j_:
							 (IRN==`jal)?`jal_:
							 (IRN==`jr)?`jr_:
							 (IRN==`jalr)?`jalr_:
							 0;
							 
		
		// begin for single instruction recognized
		assign Op = IR[`op];
		assign Func = IR[`func];
		assign Rs = IR[`rs];
		assign Rt = IR[`rt];
		
		assign IRN = (Op==6'b000000 && Func==6'b100000)?`add:
						 (Op==6'b000000 && Func==6'b100001)?`addu:
						 (Op==6'b000000 && Func==6'b100010)?`sub:
						 (Op==6'b000000 && Func==6'b100011)?`subu:
						 (Op==6'b000000 && Func==6'b000000)?`sll:
						 (Op==6'b000000 && Func==6'b000010)?`srl:
						 (Op==6'b000000 && Func==6'b000011)?`sra:
						 (Op==6'b000000 && Func==6'b000100)?`sllv:
						 (Op==6'b000000 && Func==6'b000110)?`srlv:
						 (Op==6'b000000 && Func==6'b000111)?`srav:
						 (Op==6'b000000 && Func==6'b100100)?`and_:
						 (Op==6'b000000 && Func==6'b100101)?`or_:
						 (Op==6'b000000 && Func==6'b100110)?`xor_:
						 (Op==6'b000000 && Func==6'b100111)?`nor_:
						 (Op==6'b000000 && Func==6'b101010)?`slt:
						 (Op==6'b000000 && Func==6'b101011)?`sltu:
						 // (Op==6'b000000 && Func==6'b011000)?`mult:
						 // (Op==6'b000000 && Func==6'b011001)?`multu:
						 // (Op==6'b000000 && Func==6'b011010)?`div:
						 // (Op==6'b000000 && Func==6'b011011)?`divu:
						 // (Op==6'b000000 && Func==6'b010001)?`mthi:
						 // (Op==6'b000000 && Func==6'b010011)?`mtlo:
						 // (Op==6'b000000 && Func==6'b010000)?`mfhi:
						 // (Op==6'b000000 && Func==6'b010010)?`mflo:					// end of calr
						 (Op==6'b001000)?`addi:
						 (Op==6'b001001)?`addiu:
						 (Op==6'b001100)?`andi:
						 (Op==6'b001101)?`ori:
						 (Op==6'b001110)?`xori:
						 (Op==6'b001111)?`lui:
						 (Op==6'b001010)?`slti:
						 (Op==6'b001011)?`sltiu:											// end of cali
						 (Op==6'b100011)?`lw:
						 (Op==6'b100000)?`lb:
						 (Op==6'b100100)?`lbu:
						 (Op==6'b100001)?`lh:
						 (Op==6'b100101)?`lhu:												// end of load
						 (Op==6'b101011)?`sw:
						 (Op==6'b101001)?`sh:
						 (Op==6'b101000)?`sb:												// end of store
						 (Op==6'b000100)?`beq:
						 (Op==6'b000101)?`bne:
						 (Op==6'b000110)?`blez:
						 (Op==6'b000111)?`bgtz:
						 (Op==6'b000001 && Rt==5'b00000)?`bltz:
						 (Op==6'b000001 && Rt==5'b00001)?`bgez:						// end of branch
						 (Op==6'b000010)?`j:
						 (Op==6'b000011)?`jal:
						 (Op==6'b000000 && Func==6'b001000)?`jr:
						 (Op==6'b000000 && Func==6'b001001)?`jalr:					// end of jump type instrs
						 (Op==6'b010000 && Func==6'b011000)?`eret:
						 (Op==6'b010000 && Rs==5'b00100)?`mtc0:
						 (Op==6'b010000 && Rs==5'b00000)?`mfc0:						// end of cp0 instrs
						 0;
						 
		/*				 
		// cali
		assign addi = ;
		assign addiu = ;
		assign andi = ;
		assign ori = ;
		assign xori = ;
		assign lui = ;
		assign slti = ;
		assign sltiu = (;
		// ld
		assign lw = ;
		assign lb = ;
		assign lbu = (;
		assign lh = ;
		assign lhu = ;
		// st
		assign sw = ;
		assign sh = ;
		assign sb = ;
		// b_type
		assign beq = ;
		assign bne = ;
		assign blez = ;
		assign bgtz = ;
		assign bltz = ;
		assign bgez = ;
		// j type
		assign j = ;
		assign jal = ;
		assign jr = ;
		assign jalr = ;
		*/

endmodule
