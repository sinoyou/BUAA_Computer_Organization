`timescale 1ns / 1ps
`include "head.v"
//模块类型：组合逻辑（取值）+时序逻辑（pc的更新）
//实现方式：组合逻辑-assign语句；时序逻辑always语句
module IF(Branch_Jump,Enable,Clock,Reset,PC_Update,PC4,Instr,PC);
    input Branch_Jump;
	 input Enable;
    input Clock;
    input Reset;
    input [31:0] PC_Update;
	 output [31:0] PC4;
    output [31:0] Instr;
	 output reg [31:0] PC;
	 
	 parameter initial_addr = 32'h00003000;		// pc初始化值
	 									
	 reg [31:0] im [`im_size-1:0];						// intruction memory
	 integer i;
	 
	 // 初始化
	 initial begin
		PC = initial_addr;
		for(i=0;i<=`im_size-1;i=i+1)
			im[i] = 0;
		$readmemh("code.txt", im);						// 加载指令到IM ROM
	 end
	 
	 // 组合逻辑：从IM中取指令
	 assign Instr = im[(PC - initial_addr)/4];
	 
	 // 组合逻辑：输出PC+4结果
	 assign PC4 = PC+4;
	 
	 
	 //时序逻辑 pc = pc+4 / reset / update
	 always @(posedge Clock)begin
		if(Reset)begin
			PC <= initial_addr;
		end
		else begin
			if(Enable)begin
				if(Branch_Jump)
					PC <= PC_Update;
				else 
					PC <= PC + 4;
			end
		end
	 end

endmodule
