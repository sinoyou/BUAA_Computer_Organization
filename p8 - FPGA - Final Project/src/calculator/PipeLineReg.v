/*
version 7.1 2018-12-13 在FD、DE、EM流水寄存器中新增了BD和ExcCode，MW流水寄存器中新增了CP0端口
version 7.5 2018-12-19 更改了各层寄存器Reset时的pc和BD值，pc和BD值在清除后正常流动，不受干扰（但是使能能将其暂停）.
*/
`timescale 1ns / 1ps
`include "head.v"
// 带同步复位功能和使能控制的FD级流水线寄存器
module FD_PIPE(Clock,Reset,Enable,
					F_IR,F_Pc4,F_Pc,
					F_BD,F_ExcCode,
					FD_IR,FD_Pc4,FD_Pc,
					FD_BD,FD_ExcCode);
	input Clock,Reset,Enable;
	input [31:0] F_IR;
	input [31:0] F_Pc4;
	input [31:0] F_Pc;
	input F_BD;										// new
	input [`exc_size-1:0] F_ExcCode;			// new
	output reg [31:0] FD_IR;
	output reg [31:0] FD_Pc4;
	output reg [31:0] FD_Pc;
	output reg FD_BD;								// new
	output reg [`exc_size-1:0] FD_ExcCode;	// new
	
	// 初始化
	initial begin
		FD_IR = 0 ;
		FD_Pc4 = 0;
		FD_Pc = 0;
		FD_BD = 0;
		FD_ExcCode = 0;
	end
	
	// 时序模块
	always @(posedge Clock)begin
		if(Reset)begin
			FD_IR <= 0 ;
			FD_Pc4 <= 0;
			FD_Pc <= F_Pc;// FD_Pc <= 0;
			FD_BD <= F_BD;//FD_BD <= 0;
			FD_ExcCode <= 0;
		end
		else begin
			if(Enable)begin
				FD_IR <= F_IR;
				FD_Pc4 <= F_Pc4;
				FD_Pc <= F_Pc;
				FD_BD <= F_BD;
				FD_ExcCode <= F_ExcCode;
			end
		end
	end
	
endmodule

// 带同步复位功能和使能控制的DE级流水线寄存器
module DE_PIPE(Clock,Reset,Enable,
					D_IR,D_RD1,D_RD2,D_Ext,D_Pc4,D_Pc,
					D_BD,D_ExcCode,
					DE_IR,DE_RD1,DE_RD2,DE_Ext,DE_Pc4,DE_Pc,
					DE_BD,DE_ExcCode);
	input Clock,Reset,Enable;
	input [31:0] D_IR;
	input [31:0] D_RD1;
	input [31:0] D_RD2;
	input [31:0] D_Ext;
	input [31:0] D_Pc4;
	input [31:0] D_Pc;
	input D_BD;												// new
	input [`exc_size-1:0] D_ExcCode;					// new
	output reg [31:0] DE_IR;
	output reg [31:0] DE_RD1;
	output reg [31:0] DE_RD2;
	output reg [31:0] DE_Ext;
	output reg [31:0] DE_Pc4;
	output reg [31:0] DE_Pc;
	output reg DE_BD;										// new
	output reg [`exc_size-1:0] DE_ExcCode;			// new
	
	// 初始化
	initial begin
		DE_IR = 0;
		DE_RD1 = 0;
		DE_RD2 = 0;
		DE_Ext = 0;
		DE_Pc4 = 0;
		DE_Pc = 0;
		DE_BD = 0;
		DE_ExcCode = 0;
	end
	
	// 时序逻辑
	always @(posedge Clock)begin
		if(Reset)begin
			DE_IR <= 0;
			DE_RD1 <= 0;
			DE_RD2 <= 0;
			DE_Ext <= 0;
			DE_Pc4 <= 0;
			DE_Pc <= D_Pc;// DE_Pc <= 0;
			DE_BD <= D_BD;//DE_BD <= 0;
			DE_ExcCode <= 0;
		end
		else begin
			if(Enable)begin
				DE_IR <= D_IR;
				DE_RD1 <= D_RD1;
				DE_RD2 <= D_RD2;
				DE_Ext <= D_Ext;
				DE_Pc4 <= D_Pc4;
				DE_Pc <= D_Pc;
				DE_BD <= D_BD;
				DE_ExcCode <= D_ExcCode;
			end
		end
	end
	
endmodule

// 带同步复位和使能控制的EM级流水寄存器
module EM_PIPE(Clock,Reset,Enable,
					E_IR,E_RD2,E_ALU,E_Pc,
					E_BD,E_ExcCode,
					EM_IR,EM_RD2,EM_ALU,EM_Pc,
					EM_BD,EM_ExcCode);
	input Clock,Reset,Enable;
	input [31:0] E_IR;
	input [31:0] E_RD2;
	input [31:0] E_ALU;
	input [31:0] E_Pc;
	input E_BD;													// new
	input [`exc_size-1:0] E_ExcCode;						// new
	output reg [31:0] EM_IR;
	output reg [31:0] EM_RD2;
	output reg [31:0] EM_ALU;
	output reg [31:0] EM_Pc;
	output reg EM_BD;											// new
	output reg [`exc_size-1:0] EM_ExcCode;				// new
	
	// 初始化
	initial begin
		EM_IR = 0;
		EM_RD2 = 0;
		EM_ALU = 0;
		EM_Pc = 0;
		EM_BD = 0;
		EM_ExcCode = 0;
	end
	
	// 时序逻辑
	always @(posedge Clock)begin
		if(Reset)begin
			EM_IR <= 0;
			EM_RD2 <= 0;
			EM_ALU <= 0;
			EM_Pc <= E_Pc;// EM_Pc <= 0;
			EM_BD <= E_BD;//EM_BD <= 0;
			EM_ExcCode <= 0;
		end
		else begin
			if(Enable)begin
				EM_IR <= E_IR;
				EM_RD2 <= E_RD2;
				EM_ALU <= E_ALU;
				EM_Pc <= E_Pc;
				EM_BD <= E_BD;
				EM_ExcCode <= E_ExcCode;
			end
		end
	end

endmodule

// 带同步复位和使能控制的ME级流水寄存器
module MW_PIPE(Clock,Reset,Enable,
					M_IR,M_ALU,M_MD,M_Pc,
					M_CP0,
					MW_IR,MW_ALU,MW_MD,MW_Pc,
					MW_CP0);
	input Clock,Reset,Enable;
	input [31:0] M_IR;
	input [31:0] M_ALU;
	input [31:0] M_MD;
	input [31:0] M_Pc;
	input [31:0] M_CP0;								// new
	output reg [31:0] MW_IR;
	output reg [31:0] MW_ALU;
	output reg [31:0] MW_MD;
	output reg [31:0] MW_Pc;
	output reg [31:0] MW_CP0;						// new
	
	// 初始化
	initial begin
		MW_IR = 0;
		MW_ALU = 0;
		MW_MD = 0;
		MW_Pc = 0;
		MW_CP0 = 0;
	end	
	
	// 时序逻辑
	always @(posedge Clock)begin
		if(Reset)begin
			MW_IR <= 0;
			MW_ALU <= 0;
			MW_MD <= 0;		
			MW_Pc <= M_Pc;// MW_Pc <= 0;
			MW_CP0 <= 0;
		end
		else begin
			if(Enable)begin
				MW_IR <= M_IR;
				MW_ALU <= M_ALU;
				MW_MD <= M_MD;
				MW_Pc <= M_Pc;
				MW_CP0 <= M_CP0;
			end
		end
	end
	
endmodule
