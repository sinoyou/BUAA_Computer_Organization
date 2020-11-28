/*
1. ���ע�⴫��ĵ�ַ���ݶ���byte��λ�ģ���������memʱ��word��λ�����������GRF��IM�ǲ�ͬ�ģ���
2. 
*/
`timescale 1ns / 1ps
//ģ�����ͣ�����߼�������+ʱ���߼���д��
//ʵ�ַ�ʽ��assign-����߼���always-ʱ���߼�
module DM(
    input MemWrite,
    input MemRead,
    input Clock,
    input Reset,
	 input [31:0] WPC,						// �����źţ�������display���
    input [31:0] Addr,						// address for read and write
    input [31:0] WD,							// write data
    output [31:0] RD							// read data
    );
	 parameter dm_size = 1024;
	 
	 reg [31:0] memory [dm_size-1:0];
	 integer i;
	 
	 initial begin
		for(i=0;i<=dm_size-1;i=i+1)begin
			memory[i] = 0;
		end
	 end
	 
	 // ������
	 assign RD = (MemRead)? memory[Addr/4]:32'hZZZZZZZZ;

	 // д������ͬ����λ
	 always @(posedge Clock)begin
		// ͬ����λ
		if(Reset)begin
			for(i=0;i<=dm_size-1;i=i+1)
				memory[i] <= 0;										// ��ע�⸴λ��ֵҲӦ�Ƿ�������ֵ
		end
		// д����
		else begin
			if(MemWrite)begin
				memory[Addr/4] <= WD;
				$display("%d@%h: *%h <= %h",$time,WPC,Addr,WD);
				//$display("@%h: *%h <= %h",WPC,Addr,WD);
			end
		end
	 end
endmodule
