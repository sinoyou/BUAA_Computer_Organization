/*
1、MUX使用always语句实现，请注意需要使用reg型变量。
*/
`timescale 1ns / 1ps
`include "head.v"
// mux for ALU b端口输入源
module MUX_AluSrc(AluSrc,DE_RD2,DE_Ext,DE_Pc4,AluB);
	input [`alusrc_size-1:0] AluSrc;
	input [31:0] DE_RD2;
	input [31:0] DE_Ext;
	input [31:0] DE_Pc4;
	output reg [31:0] AluB;
	
	always @(*)begin
		case(AluSrc)
			0:AluB = DE_RD2;
			1:AluB = DE_Ext;
			2:AluB = DE_Pc4;
			default:AluB = 0;
		endcase
	end

endmodule

// mux for ALU and XALU outputs select
module MUX_AluSel(AluSel,AluOut,HI,LO,Output);
	input [`alusel_size-1:0] AluSel;
	input [31:0] AluOut;
	input [31:0] HI;
	input [31:0] LO;
	output [31:0] Output;
	
	assign Output = (AluSel==0)?AluOut:
						 (AluSel==1)?HI:
						 (AluSel==2)?LO:
						 AluOut;
endmodule

// mux for GRF write address selection when WB
module MUX_WaSel(WaSel,MW_IRRt,MW_IRRd,WA);
	input [`wasel_size-1:0] WaSel;
	input [4:0] MW_IRRt;
	input [4:0] MW_IRRd;
	output reg [4:0] WA;
	
	always @(*)begin
		case(WaSel)
			0:WA = MW_IRRt;
			1:WA = MW_IRRd;
			2:WA = 31;
			default:WA = 0;
		endcase
	end
	
endmodule

// mux for GRF wirte data selection when WB
module MUX_WdSel(WdSel,MW_ALU,MW_MD,WD);
	input [`wdsel_size-1:0] WdSel;
	input [31:0] MW_ALU;
	input [31:0] MW_MD;
	output reg [31:0] WD;
	
	always @(*)begin
		case(WdSel)
			0:WD = MW_ALU;
			1:WD = MW_MD;
			default:WD = 0;
		endcase
	end
endmodule
