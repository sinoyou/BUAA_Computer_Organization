/*此模块是IF-core的替换，使用寄存器模拟，方便线下仿真时读取指令使用*/
`timescale 1ns / 1ps
`include "head.v"
//模块类型：组合逻辑（取值）+时序逻辑（pc的更新）
//实现方式：组合逻辑-assign语句；时序逻辑always语句
module IF_Sim(Branch_Jump,Enable,Clock,Clock2,Reset,Handler,PC_Update,PC4,Instr,PC,IF_Error);
    input Branch_Jump;
	 input Enable;
    input Clock;
	 input Clock2;
    input Reset;
	 input Handler;
    input [31:0] PC_Update;
	 output [31:0] PC4;
    output [31:0] Instr;
	 output reg [31:0] PC;
	 output IF_Error;
	 
	 parameter initial_addr = 32'h00003000;		// pc初始化值
	 parameter handler_addr = 32'h00004180;
	 
	 wire [31:0] pc_initial_addr;
	 wire [31:0] instr;
	 
	 
	 reg [31:0] im [`im_size-1:0];						// intruction memory
	 integer i;
	 
	 // 初始化
	 initial begin
		PC = initial_addr;
		for(i=0;i<=`im_size-1;i=i+1)
			im[i] = 0;
		$readmemh("code.txt", im);						// 加载指令到IM ROM
		$readmemh("code_handler.txt",im,1120,2047);
	 end
	 
	 // 组合逻辑：从IM中取指令
	 assign instr = im[(PC - initial_addr)/4];
	 
	 
	 // 初始化 new
	 /*initial begin
		PC = initial_addr;
	 end
	 
	 assign pc_initial_addr = (PC - initial_addr);
	 
	 IM_Core im_core (
	  .clka(Clock), // input clka
	  .ena(1'b1), // input ena
	  .wea(1'b0), // input [0 : 0] wea
	  .addra(pc_initial_addr[12:2]), // input [10 : 0] addra
	  .dina(0), // input [31 : 0] dina
	  .douta(instr) // output [31 : 0] douta
	 );*/
	 
	 // 组合逻辑：输出指令
	 assign Instr = (IF_Error)?32'h00000000:instr;
	 
	 // 组合逻辑：输出PC+4结果
	 assign PC4 = PC+4;
	 
	 // 组合逻辑：未四字节对齐输出 | 取指PC超出0x3000-0x4fff范围
	 assign IF_Error = (PC[1:0]!=0) || ~(PC>=`im_begin && PC<=`im_end);
	 
	 
	 //时序逻辑 pc = pc+4 / reset / update
	 always @(posedge Clock)begin
		if(Reset)begin
			PC <= initial_addr;
		end
		else if(Handler)begin
			PC <= handler_addr;
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


