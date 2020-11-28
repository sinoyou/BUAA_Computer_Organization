`timescale 1ns / 1ps

// 带同步复位功能和使能控制的FD级流水线寄存器
module FD_PIPE(Clock,Reset,Enable,
					F_IR,F_Pc4,F_Pc,
					FD_IR,FD_Pc4,FD_Pc);
	input Clock,Reset,Enable;
	input [31:0] F_IR;
	input [31:0] F_Pc4;
	input [31:0] F_Pc;
	output reg [31:0] FD_IR;
	output reg [31:0] FD_Pc4;
	output reg [31:0] FD_Pc;
	
	// 初始化
	initial begin
		FD_IR = 0 ;
		FD_Pc4 = 0;
		FD_Pc = 0;
	end
	
	// 时序模块
	always @(posedge Clock)begin
		if(Reset)begin
			FD_IR <= 0 ;
			FD_Pc4 <= 0;
			FD_Pc <= 0;
		end
		else begin
			if(Enable)begin
				FD_IR <= F_IR;
				FD_Pc4 <= F_Pc4;
				FD_Pc <= F_Pc;
			end
		end
	end
	
endmodule

// 带同步复位功能和使能控制的DE级流水线寄存器
module DE_PIPE(Clock,Reset,Enable,
					D_IR,D_RD1,D_RD2,D_Ext,D_Pc4,D_Pc,
					DE_IR,DE_RD1,DE_RD2,DE_Ext,DE_Pc4,DE_Pc);
	input Clock,Reset,Enable;
	input [31:0] D_IR;
	input [31:0] D_RD1;
	input [31:0] D_RD2;
	input [31:0] D_Ext;
	input [31:0] D_Pc4;
	input [31:0] D_Pc;
	output reg [31:0] DE_IR;
	output reg [31:0] DE_RD1;
	output reg [31:0] DE_RD2;
	output reg [31:0] DE_Ext;
	output reg [31:0] DE_Pc4;
	output reg [31:0] DE_Pc;
	
	// 初始化
	initial begin
		DE_IR = 0;
		DE_RD1 = 0;
		DE_RD2 = 0;
		DE_Ext = 0;
		DE_Pc4 = 0;
		DE_Pc = 0;
	end
	
	// 时序逻辑
	always @(posedge Clock)begin
		if(Reset)begin
			DE_IR <= 0;
			DE_RD1 <= 0;
			DE_RD2 <= 0;
			DE_Ext <= 0;
			DE_Pc4 <= 0;
			DE_Pc <= 0;
		end
		else begin
			if(Enable)begin
				DE_IR <= D_IR;
				DE_RD1 <= D_RD1;
				DE_RD2 <= D_RD2;
				DE_Ext <= D_Ext;
				DE_Pc4 <= D_Pc4;
				DE_Pc <= D_Pc;
			end
		end
	end
	
endmodule

// 带同步复位和使能控制的EM级流水寄存器
module EM_PIPE(Clock,Reset,Enable,
					E_IR,E_RD2,E_ALU,E_Pc,
					EM_IR,EM_RD2,EM_ALU,EM_Pc);
	input Clock,Reset,Enable;
	input [31:0] E_IR;
	input [31:0] E_RD2;
	input [31:0] E_ALU;
	input [31:0] E_Pc;
	output reg [31:0] EM_IR;
	output reg [31:0] EM_RD2;
	output reg [31:0] EM_ALU;
	output reg [31:0] EM_Pc;
	
	// 初始化
	initial begin
		EM_IR = 0;
		EM_RD2 = 0;
		EM_ALU = 0;
		EM_Pc = 0;
	end
	
	// 时序逻辑
	always @(posedge Clock)begin
		if(Reset)begin
			EM_IR <= 0;
			EM_RD2 <= 0;
			EM_ALU <= 0;
			EM_Pc <= 0;
		end
		else begin
			if(Enable)begin
				EM_IR <= E_IR;
				EM_RD2 <= E_RD2;
				EM_ALU <= E_ALU;
				EM_Pc <= E_Pc;
			end
		end
	end

endmodule

// 带同步复位和使能控制的ME级流水寄存器
module MW_PIPE(Clock,Reset,Enable,
					M_IR,M_ALU,M_MD,M_Pc,
					MW_IR,MW_ALU,MW_MD,MW_Pc);
	input Clock,Reset,Enable;
	input [31:0] M_IR;
	input [31:0] M_ALU;
	input [31:0] M_MD;
	input [31:0] M_Pc;
	output reg [31:0] MW_IR;
	output reg [31:0] MW_ALU;
	output reg [31:0] MW_MD;
	output reg [31:0] MW_Pc;
	
	// 初始化
	initial begin
		MW_IR = 0;
		MW_ALU = 0;
		MW_MD = 0;
		MW_Pc = 0;
	end	
	
	// 时序逻辑
	always @(posedge Clock)begin
		if(Reset)begin
			MW_IR <= 0;
			MW_ALU <= 0;
			MW_MD <= 0;		
			MW_Pc <= 0;
		end
		else begin
			if(Enable)begin
				MW_IR <= M_IR;
				MW_ALU <= M_ALU;
				MW_MD <= M_MD;
				MW_Pc <= M_Pc;
			end
		end
	end
	
endmodule
