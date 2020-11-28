`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:43:46 11/01/2018 
// Design Name: 
// Module Name:    debug1 
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
module debug1(
    input a,
    input b,
    output reg c
    );

	 always @(a or b)begin
		c = a&b;
	 end

endmodule
