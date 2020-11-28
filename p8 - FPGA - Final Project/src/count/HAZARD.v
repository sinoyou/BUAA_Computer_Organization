/*
version 7.1 2018.12.12 ������GID��ʹ����֧��CP0����ָ���������ģ�ͣ����Ϊ4�����ݹܵ���CP0�˿�����
version 7.1 2018.12.12 ������TRANSMITģ�飬֧�ִӵ�4���ݹܵ�����ת���Ŀ���ָ��
version 7.1 2018.12.12 ������STALLģ�飬֧��cp0ָ��֮���������2��nop��Ҫ��
version 7.2 2018.12.16 ��������ͣģ�����ͣ���ԣ���E��ΪERETָ��ʱ����ָ��ر��������Ϊ������ͣ����ʱ��ͣ��Ӱ��Ӳ������Ĺ��ܣ�
version 8.0 2018.12.24 STALLģ����ɾ����HILO�Ĵ����Ĳ�����GIDģ����ɾ����XALUָ���ʶ��Ĭ��Ϊ0)
*/
`timescale 1ns / 1ps
`include "head.v"
// ת��MUX�źſ���ģ�飺GRF_rd1,GRF_rd2,DE_rd1,DE_rd2,EM_rd2
module TRANSMIT(FD_IR,DE_IR,EM_IR,MW_IR,
					 TMux_GRF_RD1,TMux_GRF_RD2,TMux_DE_RD1,TMux_DE_RD2,TMux_EM_RD2);
		input [31:0] FD_IR;
		input [31:0] DE_IR;
		input [31:0] EM_IR;
		input [31:0] MW_IR;
		output [`tmux_size-1:0] TMux_GRF_RD1;
		output [`tmux_size-1:0] TMux_GRF_RD2;
		output [`tmux_size-1:0] TMux_DE_RD1;
		output [`tmux_size-1:0] TMux_DE_RD2;
		output [`tmux_size-1:0] TMux_EM_RD2;
		
		
		// ����GID��������д��ֵ�������,ת����������EM�㼶�����֮ǰ��������㡣
		wire EM_rwnz,MW_rwnz;
		wire [4:0] EM_a3,MW_a3;
		wire [2:0] EM_tnew,MW_tnew;
		wire [2:0] EM_dport,MW_dport;
		GID Gid3(.IR(EM_IR),.Pipe(3'd3),.RegWriteNonZero(EM_rwnz),.A3(EM_a3),.Tnew(EM_tnew),.DPort(EM_dport)),
			 Gid4(.IR(MW_IR),.Pipe(3'd4),.RegWriteNonZero(MW_rwnz),.A3(MW_a3),.Tnew(MW_tnew),.DPort(MW_dport));
		
		// ����ת��MUX�Ĺ��һ�£�0-ԭʼ�źţ�1-EM��alu�źţ�2-MW��alu�źţ�3-MW��dm�ź�
		// ת�������ж����壺A����Ҫ��������B�˵������� B�ˣ�������ͬ��C�ˣ��洢���ֵ && A�˴���ֵ�ļĴ�����B�˴���ֵ�ļĴ�����ͬ && B�˵�ֵһ�����ڽ�����д��GRF && B�˵�ֵ�Ѿ������µ���
		// mux at GRF's port RD1
		assign TMux_GRF_RD1 = ((FD_IR[`rs]==EM_a3) && EM_tnew==0 && EM_rwnz && EM_dport==`EM_ALU)?`EM_ALU:
									 ((FD_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((FD_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 ((FD_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_CP0)?`MW_CP0:
									 0;
		// mux at GRF's port RD2
		assign TMux_GRF_RD2 = ((FD_IR[`rt]==EM_a3) && EM_tnew==0 && EM_rwnz && EM_dport==`EM_ALU)?`EM_ALU:
									 ((FD_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((FD_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 ((FD_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_CP0)?`MW_CP0:
									 0;
		// mux at DE piperegister's RD1
		assign TMux_DE_RD1 =  ((DE_IR[`rs]==EM_a3) && EM_tnew==0 && EM_rwnz && EM_dport==`EM_ALU)?`EM_ALU:
									 ((DE_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((DE_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 ((DE_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_CP0)?`MW_CP0:
									 0;										
		// mux at DE piperegister's RD2
		assign TMux_DE_RD2 =  ((DE_IR[`rt]==EM_a3) && EM_tnew==0 && EM_rwnz && EM_dport==`EM_ALU)?`EM_ALU:
									 ((DE_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((DE_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 ((DE_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_CP0)?`MW_CP0:
									 0;
		// mux at EM piprregister's RD2
		assign TMux_EM_RD2 =  ((EM_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((EM_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 ((EM_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_CP0)?`MW_CP0:
									 0;		

endmodule

// ������Ŀǰ��֧����FD��DE֮�����ˮ��D��������������nop���ݡ�
module STALL(FD_IR,DE_IR,EM_IR,MW_IR,/*E_Start,E_Busy,*/Stall);
		input [31:0] FD_IR;
		input [31:0] DE_IR;
		input [31:0] EM_IR;
		input [31:0] MW_IR;
		// input [`start_size-1:0] E_Start;
		// input E_Busy;
		output Stall;
		
		wire stall_rs,stall_rt,stall_hilo,stall_cp0;
		wire [2:0] FD_tuse_rs, FD_tuse_rt;
		wire FD_hilo;
		wire FD_eret,DE_eret,DE_mtc0,EM_mtc0;
		wire [2:0] DE_tnew, EM_tnew, MW_tnew;
		wire [4:0] DE_a3, EM_a3, MW_a3;
		wire DE_rwnz,EM_rwnz,MW_rwnz;
		
		// ����GIDģ�����FD���Tuse���������Tnew���Ѿ���صļĴ���д�����
		GID Gid1(.IR(FD_IR),.Pipe(3'd1),.Tuse_Rs(FD_tuse_rs),.Tuse_Rt(FD_tuse_rt),.HiLo(FD_hilo),.ERET(FD_eret)),
			 Gid2(.IR(DE_IR),.Pipe(3'd2),.RegWriteNonZero(DE_rwnz),.A3(DE_a3),.Tnew(DE_tnew),.ERET(DE_eret),.MTC0(DE_mtc0)),
			 Gid3(.IR(EM_IR),.Pipe(3'd3),.RegWriteNonZero(EM_rwnz),.A3(EM_a3),.Tnew(EM_tnew),.MTC0(EM_mtc0)),
			 Gid4(.IR(MW_IR),.Pipe(3'd4),.RegWriteNonZero(MW_rwnz),.A3(MW_a3),.Tnew(MW_tnew));
		
		// ��ͣ�������壺FD��ָ������XX��ָ���rs����Ҫ��ͣ = FD���XX����ԵĶ�����rs && FD���rsֵ����ض�����XX���rs�ĸ�д && XX��ض����rs���и�д
		// stall because of rs
		assign stall_rs = ((FD_IR[`rs]==DE_a3) && (FD_tuse_rs<DE_tnew) && DE_rwnz)?1:
								((FD_IR[`rs]==EM_a3) && (FD_tuse_rs<EM_tnew) && EM_rwnz)?1:
								((FD_IR[`rs]==MW_a3) && (FD_tuse_rs<MW_tnew) && MW_rwnz)?1:
								0;
		// stall because of rt
		assign stall_rt = ((FD_IR[`rt]==DE_a3) && (FD_tuse_rt<DE_tnew) && DE_rwnz)?1:
								((FD_IR[`rt]==EM_a3) && (FD_tuse_rt<EM_tnew) && EM_rwnz)?1:
								((FD_IR[`rt]==MW_a3) && (FD_tuse_rt<MW_tnew) && MW_rwnz)?1:
								0;
		// stall because xalu is doing or is to do mass calculating - busy = 1 || start = 1;
		// assign stall_hilo = (FD_hilo && (E_Busy || E_Start == 1))?1:0;
		
		// stall ����CP0ָ��ٿصļĴ���ֵ��ȡ�����ڶ����ˮ�߶Σ�D��M����Ϊ��֤���£�������Ҫ���2��nop,�˴������˷�����δ���Ǿ���д��CP0�Ĵ�����š�
		assign stall_cp0 = (FD_eret)&&(DE_mtc0 || EM_mtc0);
		
		// generate
		// assign Stall = (stall_rt | stall_rs | stall_hilo | stall_cp0) && ~DE_eret;
		assign Stall = (stall_rt | stall_rs | stall_cp0) && ~DE_eret;

endmodule

// General Instruction Decoder
// ���뵱ǰָ���Լ������ڵĲ㼶�������1.Tuse_rs 2.Tuse_rt 3.RegWriteNonZero 4.A3 5.Tnew
module GID(IR,Pipe,Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort,HiLo,MTC0,ERET);
		input [31:0] IR;
		input [2:0] Pipe;							// pipeline : FD:1, DE:2, EM:3, MW:4
		output [2:0] Tuse_Rs;					// ��ǰ�㼶����ǰָ�rs�Ĵ����е�ֵ��Ҫ��ʹ�õ�ʱ������(no_more_use=7):��ǰָ�����Դ˼Ĵ���ֵ�������ˡ�������������|�Ѿ��ù��ˣ�
		output [2:0] Tuse_Rt;					// ��ǰ�㼶����ǰָ�rt�Ĵ����е�ֵ��Ҫ��ʹ�õ�ʱ������
		output RegWriteNonZero;					// ��ǰָ��Ƿ�������żĴ���д��ֵ
		output [4:0] A3;							// ��ǰָ���������Чд�룬��д���Ŀ�ĵ�
		output [2:0] Tnew;						// ��ǰ�㼶����ǰָ���������Чд�룬�������д��ֵ��ʱ��������no_more_new=0������ǰָ����ٲ����µĴ�д��ֵ���������������|�Ѿ�������
		output [2:0] DPort;						// ��ǰ�㼶����ǰָ���������Чд�룬��д����������ˮ�߼Ĵ������궨����Ϸ�����
		output HiLo;								// ��ǰ�㼶��ָ���Ƿ�Ϊmult,multu,div,divu,mfhi,mflo,mthi,mtlo����֮һ��
		output MTC0;								// ��ǰ�㼶����ǰָ��Ƿ�ΪMTC0
		output ERET;								// ��ǰ�㼶��ָ���Ƿ�Ϊeret
		
		// single instructions 
		wire add,addu,sub,subu,
			  sll,srl,sra,sllv,srlv,srav,
			  _and,_or,_xor,_nor,
			  slt,sltu;
			  // mult,multu,div,divu,
			  // mthi,mtlo,mfhi,mflo;
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
		
		// internal data
		wire [5:0] Op;
		wire [5:0] Func;
		wire [4:0] Rt;
		wire [4:0] Rs;
		
		wire [2:0] DTuse_Rs, DTuse_Rt;
		wire [2:0] DTnew;		
		wire regwrite;
		wire [4:0] wa;
		wire [2:0] dport;
		
		// ���ֵԤ���㡣
		// ��IF/ID�Ĵ�������Ϊ��׼������Tuse
		assign DTuse_Rs = (branch|jr|jalr)?0:
								(calr|cali|ld|st)?1:
								`no_more_use;
		assign DTuse_Rt = (branch)?0:
								(calr)?1:											// debug : i��ָ���Ҫrt�Ĵ�����ֵ
								(st|mtc0)?2:
								`no_more_use;
		
		// ��IF/ID�Ĵ�������Ϊ��׼������Tnew
		assign DTnew = (calr|cali|jal|jalr)?2:
							(ld|mfc0)?3:
							`no_more_new;
		
		// ����ָ�����ͣ�����RegWrite�����źţ�ͬ�������߼���
		assign regwrite = calr|cali|ld|jal|jalr|mfc0;
		
		// ����ָ�����ͣ����д��Ĵ����ı�ţ�����ͬMUX_WaSel��
		assign wa = (calr|jalr)?IR[`rd]:
						(cali|ld|mfc0)?IR[`rt]:
						(jal)?31:
						`neverwrite;
		
		// ���ݵ�ǰ�㼶��ָ�����ͣ������������������ˮ�߼Ĵ����˿�
		assign dport = ((Pipe==3'd3) && (calr|cali|jal|jalr))?`EM_ALU:
							((Pipe==3'd4) && (calr|cali|jal|jalr))?`MW_ALU:
							((Pipe==3'd4) && (ld))?`MW_MD:
							((Pipe==3'd4) && (mfc0))?`MW_CP0:
							0;
		
		// ����˿ڻ���
		assign Tuse_Rs = (DTuse_Rs-Pipe+1<3)?DTuse_Rs-Pipe+1:`no_more_use;			// ע���޷��űȽ�
		assign Tuse_Rt = (DTuse_Rt-Pipe+1<3)?DTuse_Rt-Pipe+1:`no_more_use;			// ע���޷��űȽ�
		assign RegWriteNonZero = regwrite&&(wa!=0);
		assign A3 = wa;
		assign Tnew = (DTnew-Pipe+1<4)?DTnew-Pipe+1:`no_more_new;						// ע���޷��űȽ�
		assign DPort = dport;
		// assign HiLo = mult|multu|div|divu|mfhi|mflo|mthi|mtlo;
		assign HiLo = 0;
		assign MTC0 = mtc0;
		assign ERET = eret;
			
		// begin for type instructions recognized
		assign calr = add|addu|sub|subu|
						  sll|srl|sra|sllv|srlv|srav|
						  _and|_or|_xor|_nor|
						  slt|sltu;
						  // mult|multu|div|divu|
						  // mthi|mtlo|mfhi|mflo;
		assign cali = addi|addiu|
						  andi|ori|xori|
						  lui|
						  slti|sltiu;
		assign ld = lw|lb|lbu|lh|lhu;
		assign st = sw|sh|sb;
		assign branch = beq|bne|blez|bgtz|bltz|bgez;
		// j jal jr jalr
		
		// begin for single instruction recognized
		assign Op = IR[`op];
		assign Func = IR[`func];
		assign Rt = IR[`rt];
		assign Rs = IR[`rs];
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
		/*
		assign mult = (Op==6'b000000 && Func==6'b011000);
		assign multu = (Op==6'b000000 && Func==6'b011001);
		assign div = (Op==6'b000000 && Func==6'b011010);
		assign divu = (Op==6'b000000 && Func==6'b011011);
		assign mthi = (Op==6'b000000 && Func==6'b010001);
		assign mtlo = (Op==6'b000000 && Func==6'b010011);
		assign mfhi = (Op==6'b000000 && Func==6'b010000);
		assign mflo = (Op==6'b000000 && Func==6'b010010);
		*/
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
