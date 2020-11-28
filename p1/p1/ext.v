`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:43:27 10/27/2018 
// Design Name: 
// Module Name:    ext 
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
module ext(
    input [15:0] imm,
    input [1:0] EOp,
    output reg [31:0] ext
    );
	 
	 reg [15:0] temp1 = 16'hffff, temp2 = 16'h0000;
	 reg [31:0] temp;
	 
	 always @(imm or EOp)begin
		case(EOp)
			2'b00: temp[31:0] = (imm[15] == 1)? {temp1[15:0], imm[15:0]} : {temp2[15:0], imm[15:0]};
			2'b01: temp[31:0] = {temp2[15:0], imm[15:0]};
			2'b10: temp[31:0] = {imm[15:0], temp2[15:0]};
			2'b11: begin
					temp[31:0] = (imm[15] == 1)? {temp1[15:0], imm[15:0]} : {temp2[15:0], imm[15:0]};
					temp[31:0] = temp << 2;
				 end
		endcase
		ext <= temp;
	 end
/*��˼��
1���ڶ������ߺ�ʹ������ʱ�����ߴ�С�Ķ��岻ҪŪ���ˣ��ǲ�ͬ�ġ�
2����case��if����������У���ֵ�ıȽ����Ҫ���Ͻ���������λ����
3����always����е��м���reg�������䴦���Ҫ��󸳸��˿�ֵ���������������Ը�ֵ����ô���أ� --- ԭ����������ʱ���߼�ʱҪʹ�÷�������䡣
4��ֱ�Ӷ��������з������ʺ󣬽�16λֵ����32λ��ϵͳ���Զ����и�λ�ķ�����չ��
*/


endmodule
