`timescale 1ns / 1ps
module LED_32_Driver(Clock,Reset,WD,WE,
							RD,
							Tube32);
	input Clock;
	input Reset;
	
	// 与CPU交互数据
	input WE;
	input [31:0] WD;
	output [31:0] RD;
	
	// 与外设交互数据
	output [31:0] Tube32;
	
	reg [31:0] data;
	
	// assign output wire
	assign RD = data;
	assign Tube32 = ~data;
	
	initial begin
		data = 0;
	end
	
	always @(posedge Clock)begin
		if(Reset)begin
			data <= 0;
		end
		else begin
			if(WE)begin
				data <= WD;
			end
		end
	end


endmodule
