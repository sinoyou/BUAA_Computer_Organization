/*
version 8.0 2018.12.25 修正了时钟信号问题，模块的时钟由ip-core供给，因此time_scale变量需要发生变化。
version 8.0 2018.12.27 修正了display管的真值表，与计组理论课的真值表存在差异
version 8.0 2018.12.27 修正了sel和cnt寄存器的reset设置，reset时两个寄存器不归零
version 8.0 2018.12.27 新增了符号位真值表，当sign位的值非零时，将显示符号。
version 8.0 2018.12.29 新增了使用符号位显示异常状态的功能，当sign[3]有效时将优先显示异常。
*/
`timescale 1ns / 1ps
// define the signal list based on the LED:dot a b c d e f g
`define zero  8'b0_1111_110
`define one	  8'b0_0110_000
`define two   8'b0_1101_101
`define three 8'b0_1111_001
`define four  8'b0_0110_011
`define five  8'b0_1011_011
`define six   8'b0_1011_111
`define seven 8'b0_1110_000
`define eight 8'b0_1111_111
`define nine  8'b0_1111_011
`define A     8'b0_1110_111
`define B	  8'b0_0011_111
`define C     8'b0_1001_110
`define D     8'b0_0111_101
`define E	  8'b0_1001_111
`define F     8'b0_1000_111
`define neg	  8'b0_0000_001
// define dynamic display time scale (based on 25MHz outer clock)
`include "head.v"

// 9位LED数码管驱动部件，功能：CPU数据交互（W+R） + LED控制信号（阴级驱动，由Decoder取反）
module Display_Driver(Clock,Reset,WE,Addr,WD,RD,
							 LTube4_Sel,HTube4_Sel,STube_Sel,
							 LTube4,HTube4,STube);
	input Clock;
	input Reset;

	// CPU交互端口
	input WE;
	input Addr;						// write and read address (Address[2:2])
	input [31:0] WD;				// write data
	output [31:0] RD;				// read data
	
	// 外设交互端口
	output [3:0] LTube4_Sel;	// 低4位组LEB灯管
	output [3:0] HTube4_Sel;	// 高4位组LED灯管
	output STube_Sel;				// 符号LED灯管
	output [7:0] LTube4;
	output [7:0] HTube4;
	output [7:0] STube;
	
	// wire and reg define
	reg [15:0] highdata,lowdata;	// 存储CPU写入数据的文件
	reg [3:0] signdata;
	integer count;						// 计时器（辅助显示编号寄存器）
	reg [1:0] display_num;			// 显示编号寄存器
	wire [3:0] num0,num1,num2,num3,num4,num5,num6,num7,sign;
	
	// initial part
	initial begin
		highdata = 0;
		lowdata = 0;
		signdata = 0;
		count = 0;
		display_num = 0;
	end
	
	// Function 1 : React with CPU in Read and Write
	// Read
	assign RD = (Addr==0)?{highdata[15:0],lowdata[15:0]}:{28'b0,signdata[3:0]};
	// Write
	always @(posedge Clock)begin
		if(Reset)begin
			highdata <= 0;
			lowdata <= 0;
			signdata <= 0;
		end
		else begin
			if(WE)begin
				if(Addr==0)
					{highdata[15:0],lowdata[15:0]} <= WD[31:0];
				else 
					{signdata[3:0]} <= WD[3:0];
			end
		end
	end
	
	
	// Function 2: Drive LED Tubes accoring to data in regs data
	// timer count and change display tube in one batch
	always @(posedge Clock)begin
		if(Reset&0)begin
			// count <= 0;
			// display_num <= 0;
		end
		else begin
			if(count>=`display_scale)begin
				count <= 0;
				display_num <= display_num + 1;		// support natural overflow
			end
			else begin
				count <= count + 1;
			end
		end
	end
	
	// LED tube signal decode
	// 预处理：提取每个管所对应的数字
	assign num0 = lowdata[3:0];
	assign num1 = lowdata[7:4];
	assign num2 = lowdata[11:8];
	assign num3 = lowdata[15:12];
	assign num4 = highdata[3:0];
	assign num5 = highdata[7:4];
	assign num6 = highdata[11:8];
	assign num7 = highdata[15:12];
	assign sign = signdata[3:0];
	
	// for Low Tube Batch 4
	DIS_Decoder dis_d1(
		.Display_num(display_num),
		.HNum(
			(display_num==0)?num0:
			(display_num==1)?num1:
			(display_num==2)?num2:
			(display_num==3)?num3:4'b0
		),
		.TubeSel(LTube4_Sel),
		.TubeNum(LTube4)
	);
	// for High Tube Batch 4
	DIS_Decoder dis_d2(
		.Display_num(display_num),
		.HNum(
			(display_num==0)?num4:
			(display_num==1)?num5:
			(display_num==2)?num6:
			(display_num==3)?num7:4'b0
		),
		.TubeSel(HTube4_Sel),
		.TubeNum(HTube4)
	);
	// for Sign Tube
	assign STube_Sel = 1'b1;
	assign STube = (sign[3])?(~(`F)):
						(sign[0])?(~(`neg)):
						(~(8'b0));
	/*
	DIS_Decoder dis_ds(
		.Display_num(2'd0),
		.HNum(sign),
		.TubeNum(STube)
	);
	*/


endmodule

// 译码器部件：用于将输入的"显示编号"和"十六进制数"译码成LED管的阴极控制信号和片选信号
module DIS_Decoder(HNum,Display_num,TubeSel,TubeNum);
	input [1:0] Display_num;
	input [3:0] HNum;
	output [3:0] TubeSel;
	output [7:0] TubeNum;
	
	wire [7:0] Pos_TubeNum;
	
	// OUTPUTS
	assign TubeSel = (Display_num==0)?4'b0001:
						  (Display_num==1)?4'b0010:
						  (Display_num==2)?4'b0100:
												 4'b1000;
	assign TubeNum = ~Pos_TubeNum;
	
	// process
	assign Pos_TubeNum =   (HNum==4'h0)? `zero:
								  (HNum==4'h1)? `one:
								  (HNum==4'h2)? `two:
								  (HNum==4'h3)? `three:
								  (HNum==4'h4)? `four:
								  (HNum==4'h5)? `five:
								  (HNum==4'h6)? `six:
								  (HNum==4'h7)? `seven:
								  (HNum==4'h8)? `eight:
								  (HNum==4'h9)? `nine:
								  (HNum==4'ha)? `A:
								  (HNum==4'hb)? `B:
								  (HNum==4'hc)? `C:
								  (HNum==4'hd)? `D:
								  (HNum==4'he)? `E:
								  (HNum==4'hf)? `F:
								  8'b0;

endmodule
