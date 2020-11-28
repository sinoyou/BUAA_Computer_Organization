`timescale 1ns / 1ps
module ExcCTRL(IntReq,ExcCode,BD,
					ExlSet,PPClr,WriteProtect,Handler,
					ExcSel,PcSel);
	input IntReq;
	input [6:2] ExcCode;
	input BD;
	output ExlSet;
	output PPClr;
	output WriteProtect;
	output Handler;
	// 个性化中断启动控制信号：延迟槽和中断/异常
	output ExcSel;
	output PcSel;
	
	// condition judge
	wire exc_non,exc_bd,int_non,int_bd,exc_int;
	assign exc_non = ~IntReq & (ExcCode>0) & ~BD;
	assign exc_bd  = ~IntReq & (ExcCode>0) & BD;
	assign int_non = IntReq & ~BD;
	assign int_bd  = IntReq & BD;
	assign exc_int = exc_non | exc_bd | int_non | int_bd;
	
	// output - general
	assign ExlSet = (exc_int)?1:0;
	assign PPClr = (exc_int)?1:0;
	assign WriteProtect = (exc_int)?1:0;
	assign Handler = (exc_int)?1:0;
	// output - special
	assign ExcSel = (int_non | int_bd)?1:0;
	assign PcSel = (exc_bd | int_bd)?1:0;

endmodule
