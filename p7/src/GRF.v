/* 感悟：
1. 可综合的电路中，出现时序逻辑一定要用非阻塞赋值（此题中reset信号出现时的赋值）。
2. 若要手写组合逻辑信号列表，请一定注意等号右边的所有内容都要加进去（包括数组名），同时留意warning信息。
3. 用always块实现寄存器的读不可行，因为'register'敏感信号无法列入其中
*/
`timescale 1ns / 1ps
// 模块类型：读组合逻辑+写时序逻辑
// 实现方式：一个always模块负责读（组合逻辑），一个always模块负责写（时序逻辑）
module GRF(
    input RegWrite,
    input Clock,
    input Reset,
    input [4:0] RA1,
    input [4:0] RA2,
    input [4:0] WA,
    input [31:0] WD,
	 input [31:0] WPC,									// !!!无用输入，仅用于display输出时使用
    output [31:0] RD1,
    output [31:0] RD2
    );
	 
	 parameter reg_size = 32;							// 寄存器阵列大小
	 
	 integer i;
	 reg [31:0] register [reg_size-1:0]; 			// 声明32个寄存器值
	 
	 initial begin											// 寄存器值初始化
		for(i = 0;i <= reg_size-1; i = i+1)
			register[i] = 0;
	 end
	
	 
	 // 读操作
	 assign RD1 = register[RA1];
	 assign RD2 = register[RA2];
	 
	 // 写操作:带有同步复位功能
	 always @(posedge Clock)begin
		// 复位操作
		if(Reset)begin
			for(i = 0; i <= reg_size-1; i = i+1)
				register[i] <= 0;							// 请留意这里是非阻塞赋值!
		end
		// 写操作
		else begin
			// 写操作控制信号有效，允许写;$zero不允许赋值
			if(RegWrite && WA!=0)
			begin
				register[WA] <= WD;
				$display("%d@%h: $%d <= %h",$time,WPC,WA,WD);
				$display("~%h: $%d <= %h",WPC,WA,WD);
			end
		end
	 end

endmodule
