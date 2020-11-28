`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:24 10/27/2018 
// Design Name: 
// Module Name:    gray 
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
module gray(
    input Clk,
    input Reset,
    input En,
    output reg [2:0] Output,
    output reg Overflow
    );
	 reg [2:0] counter = 0;
	 reg Overflow_temp = 0;
	 
	 // 主计数器
	 always @(posedge Clk)begin
		// 同步复位检查
		if(Reset)begin
			counter <= 0;
			Overflow_temp <= 0;
		end
		else begin
			// 使能端口检查
			if(En)begin
				// 溢出监测
				if(counter == 3'b111) Overflow_temp <= 1;
				counter <= counter + 1;
			end
		end
	 end
	 
	 // 定义输出模块，以counter or Overflow_temp变化为触发条件。
	 always @(counter or Overflow_temp)begin
		// overflow 
		Overflow = Overflow_temp;
		// gray counter
		case(counter)
			0: Output = 3'b000;
			1: Output = 3'b001;
			2: Output = 3'b011;
			3: Output = 3'b010;
			4: Output = 3'b110;
			5: Output = 3'b111;
			6: Output = 3'b101;
			7: Output = 3'b100;
		endcase
	 end

endmodule
