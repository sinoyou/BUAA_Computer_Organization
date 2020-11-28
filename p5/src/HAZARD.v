`timescale 1ns / 1ps
`define op 31:26
`define func 5:0
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define no_more_use 7
`define no_more_new 0
`define neverwrite 0
`define EM_ALU 1						// 写入数据存在端口1
`define MW_ALU 2						// 写入数据存在端口2
`define MW_MD 3						// 写入数据存在端口3

// 转发MUX信号控制模块：GRF_rd1,GRF_rd2,DE_rd1,DE_rd2,EM_rd2
module TRANSMIT(FD_IR,DE_IR,EM_IR,MW_IR,
					 TMux_GRF_RD1,TMux_GRF_RD2,TMux_DE_RD1,TMux_DE_RD2,TMux_EM_RD2);
		input [31:0] FD_IR;
		input [31:0] DE_IR;
		input [31:0] EM_IR;
		input [31:0] MW_IR;
		output [2:0] TMux_GRF_RD1;
		output [2:0] TMux_GRF_RD2;
		output [2:0] TMux_DE_RD1;
		output [2:0] TMux_DE_RD2;
		output [2:0] TMux_EM_RD2;
		
		
		// 调用GID计算各层次写入值产生情况,转发最早来自EM层级，因此之前层无需计算。
		wire EM_rwnz,MW_rwnz;
		wire [4:0] EM_a3,MW_a3;
		wire [2:0] EM_tnew,MW_tnew;
		wire [2:0] EM_dport,MW_dport;
		GID Gid3(.IR(EM_IR),.Pipe(3'd3),.RegWriteNonZero(EM_rwnz),.A3(EM_a3),.Tnew(EM_tnew),.DPort(EM_dport)),
			 Gid4(.IR(MW_IR),.Pipe(3'd4),.RegWriteNonZero(MW_rwnz),.A3(MW_a3),.Tnew(MW_tnew),.DPort(MW_dport));
		
		// 所有转发MUX的规格一致，0-原始信号，1-EM层alu信号，2-MW层alu信号，3-MW层dm信号
		// 转发条件判断语义：A端若要接受来自B端的内容则 B端（而不是同级C端）存储结果值 && A端代表值的寄存器与B端代表值的寄存器相同 && B端的值一定会在将来被写入GRF && B端的值已经是最新的了
		// mux at GRF's port RD1
		assign TMux_GRF_RD1 = ((FD_IR[`rs]==EM_a3) && EM_tnew==0 && EM_rwnz && EM_dport==`EM_ALU)?`EM_ALU:
									 ((FD_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((FD_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 0;
		// mux at GRF's port RD2
		assign TMux_GRF_RD2 = ((FD_IR[`rt]==EM_a3) && EM_tnew==0 && EM_rwnz && EM_dport==`EM_ALU)?`EM_ALU:
									 ((FD_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((FD_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 0;
		// mux at DE piperegister's RD1
		assign TMux_DE_RD1 =  ((DE_IR[`rs]==EM_a3) && EM_tnew==0 && EM_rwnz && EM_dport==`EM_ALU)?`EM_ALU:
									 ((DE_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((DE_IR[`rs]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 0;										
		// mux at DE piperegister's RD2
		assign TMux_DE_RD2 =  ((DE_IR[`rt]==EM_a3) && EM_tnew==0 && EM_rwnz && EM_dport==`EM_ALU)?`EM_ALU:
									 ((DE_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((DE_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 0;
		// mux at EM piprregister's RD2
		assign TMux_EM_RD2 =  ((EM_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_ALU)?`MW_ALU:
									 ((EM_IR[`rt]==MW_a3) && MW_tnew==0 && MW_rwnz && MW_dport==`MW_MD)?`MW_MD:
									 0;		

endmodule

// 阻塞：目前仅支持于FD、DE之间的流水段D段阻塞，将产生nop气泡。
module STALL(FD_IR,DE_IR,EM_IR,MW_IR,Stall);
		input [31:0] FD_IR;
		input [31:0] DE_IR;
		input [31:0] EM_IR;
		input [31:0] MW_IR;
		output Stall;
		
		wire stall_rs,stall_rt;
		wire [2:0] FD_tuse_rs, FD_tuse_rt;
		wire [2:0] DE_tnew, EM_tnew, MW_tnew;
		wire [4:0] DE_a3, EM_a3, MW_a3;
		wire DE_rwnz,EM_rwnz,MW_rwnz;
		
		// 调用GID模块计算FD层的Tuse和其他层的Tnew，已经相关的寄存器写情况。
		GID Gid1(.IR(FD_IR),.Pipe(3'd1),.Tuse_Rs(FD_tuse_rs),.Tuse_Rt(FD_tuse_rt)),
			 Gid2(.IR(DE_IR),.Pipe(3'd2),.RegWriteNonZero(DE_rwnz),.A3(DE_a3),.Tnew(DE_tnew)),
			 Gid3(.IR(EM_IR),.Pipe(3'd3),.RegWriteNonZero(EM_rwnz),.A3(EM_a3),.Tnew(EM_tnew)),
			 Gid4(.IR(MW_IR),.Pipe(3'd4),.RegWriteNonZero(MW_rwnz),.A3(MW_a3),.Tnew(MW_tnew));
		
		// debug 暂停：所有跳转指令后面必跟一个延迟槽
		//assign stall_debug = (DE_IR[`op]==6'b000100) || (DE_IR[`op]==6'b000011) || (DE_IR[`op]==6'b000010 || (DE_IR[`op]==6'b000000&&DE_IR[`func]==6'b001000));
		// 暂停条件语义：FD层指令由于XX层指令，在rs层面要暂停 = FD层和XX层针对的对象都是rs && FD层对rs值需求必定先于XX层对rs的改写 && XX层必定会对rs进行改写
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
		// generate
		// assign Stall = stall_rt | stall_rs | stall_debug;
		assign Stall = stall_rt | stall_rs;

endmodule


// General Instruction Decoder
// 输入当前指令以及其所在的层级，输出：1.Tuse_rs 2.Tuse_rt 3.RegWriteNonZero 4.A3 5.Tnew
module GID(IR,Pipe,Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);
		input [31:0] IR;
		input [2:0] Pipe;							// pipeline : FD:1, DE:2, EM:3, MW:4
		output [2:0] Tuse_Rs;					// 当前层级，当前指令，rs寄存器中的值将要被使用的时间间隔。(no_more_use=7):当前指令而后对此寄存器值不会用了。（根本不会用|已经用过了）
		output [2:0] Tuse_Rt;					// 当前层级，当前指令，rt寄存器中的值将要被使用的时间间隔。
		output RegWriteNonZero;					// 当前指令，是否会向非零号寄存器写入值
		output [4:0] A3;							// 当前指令，若会有有效写入，则写入的目的地
		output [2:0] Tnew;						// 当前层级，当前指令，若会有有效写入，则其产生写入值的时间间隔。（no_more_new=0）：当前指令不会再产生新的待写入值。（根本不会产生|已经产生）
		output [2:0] DPort;						// 当前层级，当前指令，若会有有效写入，其写入流经的流水线寄存器（宏定义见上方）。
		
		// 识别独立指令
		wire [5:0] Op,Func;
		assign Op[5:0] = IR[31:26];
		assign Func[5:0] = IR[5:0];
		wire addu, subu, jr, sll, ori, lw, sw, beq, lui, jal, j;
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
		
		// 指令分类
		wire calr,cali,ld,st,btype,j_type,jal_type,jr_type;
		assign calr = addu | subu | sll;
		assign cali = ori | lui;
		assign ld = lw;
		assign st = sw;
		assign btype = beq;
		assign j_type = j;
		assign jal_type = jal;
		assign jr_type = jr;
		
		// 以IF/ID寄存器层作为基准，计算Tuse
		wire [2:0] DTuse_Rs, DTuse_Rt;
		assign DTuse_Rs = (btype|jr_type)?0:
								(calr|cali|ld|st)?1:
								`no_more_use;
		assign DTuse_Rt = (btype)?0:
								(calr)?1:											// debug : i型指令不需要rt寄存器的值
								(st)?2:
								`no_more_use;
		
		// 以IF/ID寄存器层作为基准，计算Tnew
		wire [2:0] DTnew;
		assign DTnew = (calr|cali|jal_type)?2:
							(ld)?3:
							`no_more_new;
		
		// 根据指令类型，计算RegWrite控制信号（同主控器逻辑）
		wire regwrite;
		assign regwrite = calr|cali|ld|jal_type;
		
		// 根据指令类型，求出写入寄存器的编号（功能同MUX_WaSel）
		wire [4:0] wa;
		assign wa = (calr)?IR[`rd]:
						(cali|ld)?IR[`rt]:
						(jal_type)?31:
						`neverwrite;
		
		// 根据当前层级和指令类型，求出运算结果流经的流水线寄存器端口
		wire [2:0] dport;
		assign dport = ((Pipe==3'd3) && (calr|cali|jal_type))?`EM_ALU:
							((Pipe==3'd4) && (calr|cali|jal_type))?`MW_ALU:
							((Pipe==3'd4) && (ld))?`MW_MD:
							0;
		
		// 输出端口汇总
		assign Tuse_Rs = (DTuse_Rs-Pipe+1<3)?DTuse_Rs-Pipe+1:`no_more_use;			// 注意无符号比较
		assign Tuse_Rt = (DTuse_Rt-Pipe+1<3)?DTuse_Rt-Pipe+1:`no_more_use;			// 注意无符号比较
		assign RegWriteNonZero = regwrite&&(wa!=0);
		assign A3 = wa;
		assign Tnew = (DTnew-Pipe+1<4)?DTnew-Pipe+1:`no_more_new;						// 注意无符号比较
		assign DPort = dport;

endmodule
