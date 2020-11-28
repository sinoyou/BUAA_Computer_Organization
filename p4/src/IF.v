`timescale 1ns / 1ps
//模块类型：组合逻辑（取值）+时序逻辑（pc的更新）
//实现方式：组合逻辑-assign语句；时序逻辑always语句
module IF(Branch_Jump,Clock,Reset,PC_Update,PC,Instr);
    input Branch_Jump;
    input Clock;
    input Reset;
    input [31:0] PC_Update;
    output reg [31:0] PC;								// PC
    output [31:0] Instr;
	 
	 parameter initial_addr = 32'h00003000;		// pc初始化值
	 parameter IM_size = 1024;							// im 大小
	 									
	 reg [31:0] im [IM_size-1:0];						// intruction memory
	 integer i;
	 
	 // 初始化
	 initial begin
		PC = initial_addr;
		for(i=0;i<=IM_size-1;i=i+1)
			im[i] = 0;
		$readmemh("code.txt", im);						// 加载指令到IM ROM
	 end
	 
	 // 组合逻辑：从IM中取指令
	 assign Instr = im[(PC - initial_addr)/4];
	 
	 
	 //时序逻辑 pc = pc+4 / reset / update
	 always @(posedge Clock)begin
		if(Reset)begin
			PC <= initial_addr;
		end
		else begin
			if(Branch_Jump)
				PC <= PC_Update;
			else 
				PC <= PC + 4;
		end
	 end

endmodule
