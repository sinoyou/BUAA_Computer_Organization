/* ����
1. ���ۺϵĵ�·�У�����ʱ���߼�һ��Ҫ�÷�������ֵ��������reset�źų���ʱ�ĸ�ֵ����
2. ��Ҫ��д����߼��ź��б���һ��ע��Ⱥ��ұߵ��������ݶ�Ҫ�ӽ�ȥ����������������ͬʱ����warning��Ϣ��
3. ��always��ʵ�ּĴ����Ķ������У���Ϊ'register'�����ź��޷���������
*/
`timescale 1ns / 1ps
// ģ�����ͣ�������߼�+дʱ���߼�
// ʵ�ַ�ʽ��һ��alwaysģ�鸺���������߼�����һ��alwaysģ�鸺��д��ʱ���߼���
module GRF(
    input RegWrite,
    input Clock,
    input Reset,
    input [4:0] RA1,
    input [4:0] RA2,
    input [4:0] WA,
    input [31:0] WD,
	 input [31:0] WPC,									// !!!�������룬������display���ʱʹ��
    output [31:0] RD1,
    output [31:0] RD2
    );
	 
	 parameter reg_size = 32;							// �Ĵ������д�С
	 
	 integer i;
	 reg [31:0] register [reg_size-1:0]; 			// ����32���Ĵ���ֵ
	 
	 initial begin											// �Ĵ���ֵ��ʼ��
		for(i = 0;i <= reg_size-1; i = i+1)
			register[i] = 0;
	 end
	
	 
	 // ������
	 assign RD1 = register[RA1];
	 assign RD2 = register[RA2];
	 
	 // д����:����ͬ����λ����
	 always @(posedge Clock)begin
		// ��λ����
		if(Reset)begin
			for(i = 0; i <= reg_size-1; i = i+1)
				register[i] <= 0;							// �����������Ƿ�������ֵ!
		end
		// д����
		else begin
			// д���������ź���Ч������д;$zero������ֵ
			if(RegWrite && WA!=0)
			begin
				register[WA] <= WD;
				$display("%d@%h: $%d <= %h",$time,WPC,WA,WD);
				$display("~%h: $%d <= %h",WPC,WA,WD);
			end
		end
	 end

endmodule
