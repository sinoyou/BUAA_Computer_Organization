`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:20:20 10/31/2018 
// Design Name: 
// Module Name:    debug_zongxian 
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
module debug_zongxian(
    output reg [7:0] out
    );
	 
	 reg [7:0] temp;
	 
	 initial begin
		temp = 8'b11101100;
		out = {temp[7],3'b0};
	 end



endmodule
