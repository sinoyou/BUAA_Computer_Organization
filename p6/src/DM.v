/*
1. ���ע�⴫��ĵ�ַ���ݶ���byte��λ�ģ���������memʱ��word��λ�����������GRF��IM�ǲ�ͬ�ģ���
2. 
*/
`timescale 1ns / 1ps
`include "head.v"
//ģ�����ͣ�����߼�������+ʱ���߼���д��
//ʵ�ַ�ʽ��assign-����߼���always-ʱ���߼�
module DM(
    input MemWrite,
    input MemRead,
	 input [`store_type_size-1:0] Store_Type,					// д�����Ϳ����źţ�0-word��1-halfword��2-byte
	 input [`load_type_size-1:0] Load_Type,					// �������Ϳ����źţ�0-word, 1-halfword, 2-byte
	 input SignRead,						// ����byte��halfword�����źţ��Ƿ���Ҫ������չ.
    input Clock,
    input Reset,
	 input [31:0] WPC,						// �����źţ�������display���
    input [31:0] Addr,						// address for read and write
    input [31:0] WD,							// write data
    output [31:0] RD							// read data
    );
	 
	 reg [31:0] memory [`dm_size-1:0];
	 integer i;
	 wire [31:0] datatowrite;
	 wire [3:0] byteenable;
	 wire [31:0] rd;
	 wire [31:0] datatoread;
	 
	 assign rd = memory[Addr/4];
	 
	 initial begin
		for(i=0;i<=`dm_size-1;i=i+1)begin
			memory[i] = 0;
		end
	 end
	 
	 // ������
	 MDS mds(.LoadType(Load_Type),.SignRead(SignRead),.Addr(Addr[1:0]),.Word(rd),.RD(datatoread));
	 assign RD = (MemRead)? datatoread:32'hZZZZZZZZ;
	 
	 
	 // д
	 // д����Ԥ����
	 BED Bed(.StoreType(Store_Type),.Addr(Addr[1:0]),.ByteEnable(byteenable));
	 assign datatowrite = (byteenable==4'b1111)?WD:
								 (byteenable==4'b0011)?{rd[31:16],WD[15:0]}:
								 (byteenable==4'b1100)?{WD[15:0],rd[15:0]}:
								 (byteenable==4'b0001)?{rd[31:8],WD[7:0]}:
								 (byteenable==4'b0010)?{rd[31:16],WD[7:0],rd[7:0]}:
								 (byteenable==4'b0100)?{rd[31:24],WD[7:0],rd[15:0]}:
								 (byteenable==4'b1000)?{WD[7:0],rd[23:0]}:
								 WD;
	 
	 // д������ͬ����λ
	 always @(posedge Clock)begin
		// ͬ����λ
		if(Reset)begin
			for(i=0;i<=`dm_size-1;i=i+1)
				memory[i] <= 0;										// ��ע�⸴λ��ֵҲӦ�Ƿ�������ֵ
		end
		// д����
		else begin
			if(MemWrite)begin
				memory[Addr/4] <= datatowrite;
				$display("%d@%h: *%h <= %h",$time,WPC,{Addr[31:2],2'b0},datatowrite);
				$display("~%h: *%h <= %h",WPC,{Addr[31:2],2'b0},datatowrite);
			end
		end
	 end
endmodule

// .v�ڲ��� - BED
// DM�ֽ�дʹ�������� Byte Enable Decoder
module BED(StoreType,Addr,ByteEnable);
	input [`store_type_size-1:0] StoreType;
	input [1:0] Addr;
	output [3:0] ByteEnable;
	
	assign ByteEnable = (StoreType==0)?4'b1111:
								(StoreType==1&&Addr[1]==1)?4'b1100:
								(StoreType==1&&Addr[1]==0)?4'b0011:
								(StoreType==2&&Addr[1:0]==0)?4'b0001:
								(StoreType==2&&Addr[1:0]==1)?4'b0010:
								(StoreType==2&&Addr[1:0]==2)?4'b0100:
								(StoreType==2&&Addr[1:0]==3)?4'b1000:
								 0;
endmodule

// .v�ڲ��ļ� - MDS
// DM����ѡ���� memory data select
module MDS(LoadType,SignRead,Addr,Word,RD);
	input [`load_type_size-1:0] LoadType;
	input SignRead;
	input [1:0] Addr;
	input [31:0] Word;
	output [31:0] RD;
	
	assign RD = (LoadType==0)?Word:
					(LoadType==1&&Addr[1]==0&&SignRead==1)?{{16{Word[15]}},Word[15:0]}:
					(LoadType==1&&Addr[1]==0&&SignRead==0)?{{16{1'b0}},Word[15:0]}:
					(LoadType==1&&Addr[1]==1&&SignRead==1)?{{16{Word[31]}},Word[31:16]}:
					(LoadType==1&&Addr[1]==1&&SignRead==0)?{{16{1'b0}},Word[31:16]}:
					(LoadType==2&&Addr[1:0]==0&&SignRead==1)?{{24{Word[7]}},Word[7:0]}:
					(LoadType==2&&Addr[1:0]==0&&SignRead==0)?{{24{1'b0}},Word[7:0]}:
					(LoadType==2&&Addr[1:0]==1&&SignRead==1)?{{24{Word[15]}},Word[15:8]}:
					(LoadType==2&&Addr[1:0]==1&&SignRead==0)?{{24{1'b0}},Word[15:8]}:
					(LoadType==2&&Addr[1:0]==2&&SignRead==1)?{{24{Word[23]}},Word[23:16]}:
					(LoadType==2&&Addr[1:0]==2&&SignRead==0)?{{24{1'b0}},Word[23:16]}:
					(LoadType==2&&Addr[1:0]==3&&SignRead==1)?{{24{Word[31]}},Word[31:24]}:
					(LoadType==2&&Addr[1:0]==3&&SignRead==0)?{{24{1'b0}},Word[31:24]}:	
					Word;
endmodule
