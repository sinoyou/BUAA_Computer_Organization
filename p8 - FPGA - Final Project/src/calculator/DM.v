/*
1. version 7.0 - 2018.12.10 - BEDģ��������dp��װ�㣬DM�����ź�ɾ��Store_Type����ByteEnable
2. version 7.0 - 2018.12.11 - ������д��ַ�����жϣ�������ַ��Χ�����ݽ����ᱻд�룬Ҳ���������
3. version 8.0 - 2018.12.23 - ������MDSģ��
4. version 8.0 - 2018.12.24 - (������)������dmģ�飬��λip-core�͡�(ip-core�Ķ�д�ǽ�����еģ�������������߼�-û�б�Ҫ�������������ύ��д������ʱ���߼�-��Ҫ��������ʱ�ȶ����ύ)
5. version 8.0 - 2018.12.24 - �仯��λƴ�Ӳ��ԣ������ȡ����д�롣
*/
`timescale 1ns / 1ps
`include "head.v"
module DM(
    input Clock1,
	 input Clock2,
    input Reset,
	 input [3:0]ByteEnable,
	 input [31:0] WPC,													// �����źţ�������display���
    input [31:0] Addr,													// address for read and write
    input [31:0] WD,														// write data
    output [31:0] RD														// read data
    );
	 
	 wire [31:0] datatowrite;
	 wire [31:0] rd;
	 
	 DM_Core dm_core (
	  .clka(Clock2), // input clka
	  .ena(1'b1), // input ena
	  .wea(ByteEnable), // input [3 : 0] wea
	  .addra(Addr[12:2]), // input [10 : 0] addra
	  .dina(datatowrite), // input [31 : 0] dina
	  .douta(rd) // output [31 : 0] douta
	 );
	
	 // ��
	 assign RD = rd;
	  
	 // д
	 // д����Ԥ����
	 assign datatowrite = WD << {Addr[1:0],3'b0};
endmodule


// .v�ڲ��� - BED
// DM�ֽ�дʹ�������� Byte Enable Decoder
module BED(StoreType,MemWrite,Addr,ByteEnable);
	input [`store_type_size-1:0] StoreType;
	input [1:0] Addr;
	input MemWrite;
	output [3:0] ByteEnable;
	
	wire [3:0] byteenable;
	
	assign ByteEnable = (MemWrite)?byteenable:4'b0000;
	
	assign byteenable =  (StoreType==0)?4'b1111:
								(StoreType==1&&Addr[1]==1)?4'b1100:
								(StoreType==1&&Addr[1]==0)?4'b0011:
								(StoreType==2&&Addr[1:0]==0)?4'b0001:
								(StoreType==2&&Addr[1:0]==1)?4'b0010:
								(StoreType==2&&Addr[1:0]==2)?4'b0100:
								(StoreType==2&&Addr[1:0]==3)?4'b1000:
								 4'b0000;
endmodule

// .v�ڲ��ļ� - MDS
// DM����ѡ���� memory data select
module MDS(LoadType,SignRead,MemRead,Addr,Word,RD);
	input [`load_type_size-1:0] LoadType;
	input SignRead;
	input MemRead;
	input [1:0] Addr;
	input [31:0] Word;
	output [31:0] RD;
	
	wire [31:0] rd;
	
	assign RD = (MemRead)?rd:32'hZZZZZZZZ;
	
	assign rd = (LoadType==0)?Word:
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

/*module DM(
    // input MemWrite,
    // input MemRead,
	 //input [`store_type_size-1:0] Store_Type,					// д�����Ϳ����źţ�0-word��1-halfword��2-byte
	 //input [`load_type_size-1:0] Load_Type,						// �������Ϳ����źţ�0-word, 1-halfword, 2-byte
	 //input SignRead,														// ����byte��halfword�����źţ��Ƿ���Ҫ������չ.
    input Clock,
    input Reset,
	 input [3:0]ByteEnable,
	 input [31:0] WPC,													// �����źţ�������display���
    input [31:0] Addr,													// address for read and write
    input [31:0] WD,														// write data
    output [31:0] RD														// read data
    );
	 
	 reg [31:0] memory [`dm_size-1:0];
	 integer i;
	 wire [31:0] datatowrite;
	 wire [31:0] rd;
	 wire [31:0] datatoread;
	 
	 assign rd = memory[Addr/4];
	 
	 initial begin
		for(i=0;i<=`dm_size-1;i=i+1)begin
			memory[i] = 0;
		end
	 end
	 
	 // ������
	 // MDS mds(.LoadType(Load_Type),.SignRead(SignRead),.Addr(Addr[1:0]),.Word(rd),.RD(datatoread));
	 assign RD = (MemRead && (Addr[31:2]>=0 && Addr[31:2]<=`dm_size-1))? rd:32'hZZZZZZZZ;
	 
	 
	 // д
	 // д����Ԥ����
	 // BED Bed(.StoreType(Store_Type),.Addr(Addr[1:0]),.ByteEnable(byteenable));
	 assign datatowrite = (ByteEnable==4'b1111)?WD:
								 (ByteEnable==4'b0011)?{rd[31:16],WD[15:0]}:
								 (ByteEnable==4'b1100)?{WD[15:0],rd[15:0]}:
								 (ByteEnable==4'b0001)?{rd[31:8],WD[7:0]}:
								 (ByteEnable==4'b0010)?{rd[31:16],WD[7:0],rd[7:0]}:
								 (ByteEnable==4'b0100)?{rd[31:24],WD[7:0],rd[15:0]}:
								 (ByteEnable==4'b1000)?{WD[7:0],rd[23:0]}:
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
			if(MemWrite && (`dm_high_edge>=Addr))begin
				memory[Addr/4] <= datatowrite;
				$display("%d@%h: *%h <= %h",$time,WPC,{Addr[31:2],2'b0},datatowrite);
				$display("~%h: *%h <= %h",WPC,{Addr[31:2],2'b0},datatowrite);
			end
		end
	 end
endmodule
*/
