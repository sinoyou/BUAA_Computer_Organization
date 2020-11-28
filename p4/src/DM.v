/*
1. 务必注意传入的地址内容都是byte单位的，但在索引mem时是word单位（这种情况与GRF和IM是不同的）。
2. 
*/
`timescale 1ns / 1ps
//模块类型：组合逻辑（读）+时序逻辑（写）
//实现方式：assign-组合逻辑；always-时序逻辑
module DM(
    input MemWrite,
    input MemRead,
    input Clock,
    input Reset,
	 input [31:0] WPC,						// 无用信号，仅用于display检查
    input [31:0] Addr,						// address for read and write
    input [31:0] WD,							// write data
    output [31:0] RD							// read data
    );
	 parameter dm_size = 1024;
	 
	 reg [31:0] memory [dm_size-1:0];
	 integer i;
	 
	 initial begin
		for(i=0;i<=dm_size-1;i=i+1)begin
			memory[i] = 0;
		end
	 end
	 
	 // 读操作
	 assign RD = (MemRead)? memory[Addr/4]:32'hZZZZZZZZ;

	 // 写操作与同步复位
	 always @(posedge Clock)begin
		// 同步复位
		if(Reset)begin
			for(i=0;i<=dm_size-1;i=i+1)
				memory[i] <= 0;										// 请注意复位赋值也应是非阻塞赋值
		end
		// 写操作
		else begin
			if(MemWrite)begin
				memory[Addr/4] <= WD;
				$display("@%h: *%h <= %h",WPC, Addr,WD);
			end
		end
	 end
endmodule
