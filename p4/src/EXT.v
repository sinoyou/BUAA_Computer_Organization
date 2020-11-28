// ע��㣺16{1'b1}��㻹�м��ϴ�����---{16{1'b1}}
// ģ�����ͣ�����߼�
// ʵ�֣�always
`timescale 1ns / 1ps
module EXT(ExtOp, Input, Output);
	 input ExtOp;
    input [15:0] Input;
    output reg signed [31:0] Output;
	 
	 always @(*)begin
		if(ExtOp)begin
			Output = {{16{Input[15]}}, Input[15:0]};
		end
		else begin
			Output = {{16{1'b0}}, Input[15:0]};
		end
	 end

endmodule
