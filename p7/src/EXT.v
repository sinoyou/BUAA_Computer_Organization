// 注意点：16{1'b1}外层还有加上大括号---{16{1'b1}}
// 模块类型：组合逻辑
// 实现：always
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
