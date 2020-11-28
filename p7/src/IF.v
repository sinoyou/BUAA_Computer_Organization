/*
version 7.0 - 2018.12.10 ����IF_Error�˿ڣ����д���ʱ�������4�ֽڶ��룩
version 7.0 - 2018.12.10 ����Handler�˿ڣ���Чʱ������handler code ��ַ
version 7.0 - 2018.12.19 �޸�������������ַ�����롢��ַ������Χʱ���ָ��Ϊnop
*/
`timescale 1ns / 1ps
`include "head.v"
//ģ�����ͣ�����߼���ȡֵ��+ʱ���߼���pc�ĸ��£�
//ʵ�ַ�ʽ������߼�-assign��䣻ʱ���߼�always���
module IF(Branch_Jump,Enable,Clock,Reset,Handler,PC_Update,PC4,Instr,PC,IF_Error);
    input Branch_Jump;
	 input Enable;
    input Clock;
    input Reset;
	 input Handler;
    input [31:0] PC_Update;
	 output [31:0] PC4;
    output [31:0] Instr;
	 output reg [31:0] PC;
	 output IF_Error;
	 
	 parameter initial_addr = 32'h00003000;		// pc��ʼ��ֵ
	 parameter handler_addr = 32'h00004180;
	 
	 reg [31:0] im [`im_size-1:0];						// intruction memory
	 integer i;
	 
	 // ��ʼ��
	 initial begin
		PC = initial_addr;
		for(i=0;i<=`im_size-1;i=i+1)
			im[i] = 0;
		$readmemh("code.txt", im);						// ����ָ�IM ROM
		$readmemh("code_handler.txt",im,1120,2047);
	 end
	 
	 // ����߼�����IM��ȡָ��
	 assign Instr = (IF_Error)?32'h00000000:im[(PC - initial_addr)/4];
	 
	 // ����߼������PC+4���
	 assign PC4 = PC+4;
	 
	 // ����߼���δ���ֽڶ������ | ȡָPC����0x3000-0x4ffc��Χ
	 assign IF_Error = (PC[1:0]!=0) || ~(PC>=32'h00003000 && PC<=32'h00004ffc);
	 
	 
	 //ʱ���߼� pc = pc+4 / reset / update
	 always @(posedge Clock)begin
		if(Reset)begin
			PC <= initial_addr;
		end
		else if(Handler)begin
			PC <= handler_addr;
		end
		else begin
			if(Enable)begin
				if(Branch_Jump)
					PC <= PC_Update;
				else 
					PC <= PC + 4;
			end
		end
	 end

endmodule


