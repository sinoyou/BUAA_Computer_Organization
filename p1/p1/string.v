`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:58 10/27/2018 
// Design Name: 
// Module Name:    string 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module string(
    input clk,
    input clr,
    input [7:0] in,
    output reg out
    );
	 reg [2:0] state;
	 reg whole_sentence;
	 
	 initial begin
		state = 3'b001;
		whole_sentence = 1;
	 end
	 
	 // ״̬ת��ģ��
	 always @(posedge clk or posedge clr)begin
		// �첽��λ
		if(clr)begin
			state <= 3'b001;
			whole_sentence <= 1;
		end
		// ��������
		else begin
			case(state)
				3'b001: begin
						if(in>="0"&&in<="9")state <= 3'b010;
						else begin
								  state <= 3'b001;
								  whole_sentence <= 0;
							  end
					end
				3'b010: begin
						if(in=="+"||in=="*")state <= 3'b100;
						else begin
								  state <= 3'b001;
								  whole_sentence <= 0;
							  end
					end
				3'b100: begin
						if(in>="0"&&in<="9")state <= 3'b010;
						else begin
								  state <= 3'b001;
								  whole_sentence <= 0;
							  end
					end
				default: begin
								state <= 3'b001;
								whole_sentence <= 0;
							end
			endcase
		end
	 end
	 
	 // ����ж�ģ��
	 always @(state or whole_sentence)begin
		if(state == 3'b010 && whole_sentence)
		out = 1;
		else
		out = 0;
	 end
endmodule

/*
1.��ϸ���⣬������ĸҲ�ǳ�����F��ͨ��ʱ��״̬ͼҲ�ɿ�����
2.����ʵ���Ͽ��Կ���ʹ��������״̬�����д���
һ��״̬������Ч��׺�жϣ�001 - �մ� ��010 - F �� 100 - F+Op
����״̬�������ж�F��F+Op״̬ʱ���Ƿ��ǴӴ�ͷ��ʼ�ģ�
out = 1 ���ҽ��� ��׺ΪF���ж��ǴӴ�ͷ��ʼ�ġ�
3.һ��״̬����ת�ƣ���F״ֻ̬�������Op�ŵ�F+Op״̬��F+Op״ֻ̬��������F���ܵ�F״̬������������Ѿ����� -> �մ��Ҵ�ͷ��ʼ��ʧЧ��
*/
