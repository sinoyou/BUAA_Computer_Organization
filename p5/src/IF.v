`timescale 1ns / 1ps
//ģ�����ͣ�����߼���ȡֵ��+ʱ���߼���pc�ĸ��£�
//ʵ�ַ�ʽ������߼�-assign��䣻ʱ���߼�always���
module IF(Branch_Jump,Enable,Clock,Reset,PC_Update,PC4,Instr,PC);
    input Branch_Jump;
	 input Enable;
    input Clock;
    input Reset;
    input [31:0] PC_Update;
	 output [31:0] PC4;
    output [31:0] Instr;
	 output reg [31:0] PC;
	 
	 parameter initial_addr = 32'h00003000;		// pc��ʼ��ֵ
	 parameter IM_size = 1024;							// im ��С
	 									
	 reg [31:0] im [IM_size-1:0];						// intruction memory
	 integer i;
	 
	 // ��ʼ��
	 initial begin
		PC = initial_addr;
		for(i=0;i<=IM_size-1;i=i+1)
			im[i] = 0;
		$readmemh("code.txt", im);						// ����ָ�IM ROM
	 end
	 
	 // ����߼�����IM��ȡָ��
	 assign Instr = im[(PC - initial_addr)/4];
	 
	 // ����߼������PC+4���
	 assign PC4 = PC+4;
	 
	 
	 //ʱ���߼� pc = pc+4 / reset / update
	 always @(posedge Clock)begin
		if(Reset)begin
			PC <= initial_addr;
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
