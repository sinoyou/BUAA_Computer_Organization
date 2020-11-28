`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:37:37 10/30/2018 
// Design Name: 
// Module Name:    debug_two_always 
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
module debug_two_always(
    input clk,
	 input reset,
    output reg p,
	 output reg q
    );
	 
	 initial begin
		p = 0;
		q = 0;
	 end
	 
	 always @(posedge clk)begin
		p <= 1;
	 end
	 
	 always @(p)begin
		q = ~p;
	 end

endmodule
