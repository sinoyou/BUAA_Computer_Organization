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
	 
	 // 状态转移模块
	 always @(posedge clk or posedge clr)begin
		// 异步复位
		if(clr)begin
			state <= 3'b001;
			whole_sentence <= 1;
		end
		// 正常运行
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
	 
	 // 输出判定模块
	 always @(state or whole_sentence)begin
		if(state == 3'b010 && whole_sentence)
		out = 1;
		else
		out = 0;
	 end
endmodule

/*
1.仔细审题，单个字母也是成立的F，通过时序状态图也可看出。
2.本题实际上可以看做使用了两个状态机进行处理
一号状态机：有效后缀判断，001 - 空串 ；010 - F ； 100 - F+Op
二号状态机：在判断F或F+Op状态时，是否还是从串头开始的？
out = 1 当且仅当 后缀为F且判断是从串头开始的。
3.一号状态机的转移：在F状态只有添加了Op才到F+Op状态，F+Op状态只有输入了F才能到F状态，其他情况下已经构成 -> 空串且串头开始符失效。
*/
