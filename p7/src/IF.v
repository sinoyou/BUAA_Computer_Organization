/*
version 7.0 - 2018.12.10 新增IF_Error端口，运行错误时输出（不4字节对齐）
version 7.0 - 2018.12.10 新增Handler端口，有效时将载入handler code 地址
version 7.0 - 2018.12.19 修改输出结果，当地址不对齐、地址超出范围时输出指令为nop
*/
`timescale 1ns / 1ps
`include "head.v"
//模块类型：组合逻辑（取值）+时序逻辑（pc的更新）
//实现方式：组合逻辑-assign语句；时序逻辑always语句
module IF(Branch_Jump,Enable,Clock,Reset,Handler,PC_Update,PC4,Instr,PC,IF_Error);
    input Branch_Jump;
	 input Enable;
    input Clock;
    input Reset;
	 input Handler;
    input [31:0] PC_Update;
	 output [31:0] PC4;
    output [31:0] Instr;
	 output reg [31:0] PC;
	 output IF_Error;
	 
	 parameter initial_addr = 32'h00003000;		// pc初始化值
	 parameter handler_addr = 32'h00004180;
	 
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
	 assign Instr = (IF_Error)?32'h00000000:im[(PC - initial_addr)/4];
	 
	 // 组合逻辑：输出PC+4结果
	 assign PC4 = PC+4;
	 
	 // 组合逻辑：未四字节对齐输出 | 取指PC超出0x3000-0x4ffc范围
	 assign IF_Error = (PC[1:0]!=0) || ~(PC>=32'h00003000 && PC<=32'h00004ffc);
	 
	 
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


