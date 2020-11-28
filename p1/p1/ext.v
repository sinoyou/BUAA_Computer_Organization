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
/*反思：
1、在定义总线和使用总线时，总线大小的定义不要弄反了，是不同的。
2、在case、if等条件语句中，数值的比较务必要加上进制描述和位数。
3、在always语句中的中间型reg变量，其处理后要最后赋给端口值，若不采用阻塞性赋值，怎么办呢？ --- 原话：在描述时序逻辑时要使用非阻塞语句。
4、直接定义数的有符号性质后，将16位值赋给32位，系统会自动进行高位的符号扩展。
*/


endmodule
