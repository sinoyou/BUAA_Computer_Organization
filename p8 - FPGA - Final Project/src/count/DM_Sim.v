// ��������p8�����dm�ļ���ʹ����registerģ�⣬�ӿ���Dm-core�����ȫһ�£������ڴ��������������
`timescale 1ns / 1ps
`include "head.v"
//ģ�����ͣ�����߼�������+ʱ���߼���д��
//ʵ�ַ�ʽ��assign-����߼���always-ʱ���߼�
module DM_Sim(
    input Clock1,
	 input Clock2,
    input Reset,
	 input [3:0]ByteEnable,
	 input [31:0] WPC,													// �����źţ�������display���
    input [31:0] Addr,													// address for read and write
    input [31:0] WD,														// write data
    output [31:0] RD														// read data
    );
	 
	 wire [31:0] shift_data;
	 wire [31:0] datatowrite;
	 
	 reg [31:0] dm [`dm_size-1:0];
	 integer i = 0;
	 
	 initial begin
		for(i=0;i<`dm_size;i=i+1)begin
			dm[i] = 0;
		end
	 end
	 
	 // ��
	 assign RD = dm[Addr[12:2]];
	  
	 // д
	 // д����Ԥ����
	 assign shift_data = WD << {Addr[1:0],3'b0};
	 assign datatowrite[7:0]   = (ByteEnable[0])?shift_data[7:0]:RD[7:0];
	 assign datatowrite[15:8]  = (ByteEnable[1])?shift_data[15:8]:RD[15:8];
	 assign datatowrite[23:16] = (ByteEnable[2])?shift_data[23:16]:RD[23:16];
	 assign datatowrite[31:24] = (ByteEnable[3])?shift_data[31:24]:RD[31:24];
	 always @(posedge Clock1)begin
		if(Reset)begin
			for(i=0;i<`dm_size;i=i+1)begin
				dm[i] <= 0;
			end
		end
		else begin
			dm[Addr[12:2]] <= datatowrite;
			if(ByteEnable!=4'b0000)begin
				$display("%d@%h: *%h <= %h",$time,WPC,{Addr[31:2],2'b0},datatowrite);
				$display("~%h: *%h <= %h",WPC,{Addr[31:2],2'b0},datatowrite);
			end
		end
	 end
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
