`timescale 1ns / 1ps
module Key_Driver(RD,
						Key);
	
	// ��cpu��������
	output [31:0] RD;
	
	// ���ⲿ�豸��������
	input [7:0] Key;				// Use key botton (��֧��reset�ź�)
	
	
	assign RD = {24'b0,~Key[7:0]};

endmodule

module Switch_Driver(Addr,RD,
							Switch0,Switch1,Switch2,Switch3,Switch4,Switch5,Switch6,Switch7);
		
	// ��CPU�����ź�
	input Addr;
	output [31:0] RD;
	
	// ���ⲿ�豸�����ź�
	input [7:0] Switch0;			// Switch botton
	input [7:0] Switch1;			// Switch botton
	input [7:0] Switch2;			// Switch botton
	input [7:0] Switch3;			// Switch botton
	input [7:0] Switch4;			// Switch botton
	input [7:0] Switch5;			// Switch botton	
	input [7:0] Switch6;			// Switch botton
	input [7:0] Switch7;			// Switch botton
	
	wire [31:0] rd_switch0,rd_switch1;
	
	assign RD = (Addr==0)?rd_switch0:rd_switch1;
	
	assign rd_switch0 = ~{Switch3[7:0],Switch2[7:0],Switch1[7:0],Switch0[7:0]};
	assign rd_switch1 = ~{Switch7[7:0],Switch6[7:0],Switch5[7:0],Switch4[7:0]};

endmodule
