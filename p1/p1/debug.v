`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:39:20 10/27/2018 
// Design Name: 
// Module Name:    debug 
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
module debug(
    input [7:0] in,
    input clk,
    output reg out
    );
	 reg [1:0] in_state = 0;
	 
	 // 输入译码
	 // 楼主的意思：always @(posegde clk)begin
	 // 将时序逻辑改成组合逻辑：always @(in)begin
	 always @(in)begin
		if(in >= "0" && in <="9")in_state <= 1;
		else if (in == "+" || in == "*")in_state <= 2;
		else in_state <= 0;
	 end
	 
	 // 状态转移
	 always @(posedge clk)begin
		if(in_state == 1) out <= 1;
		else out <= 0;
	 end

endmodule
