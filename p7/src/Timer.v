/*
version 7.1 - 2018.12.12 更改了CNT->INT的条件，从等于变为小于等于、
version 7.5 - 2018.12.19 优化了对CTRL寄存器位数的调用，定义了wire型变量方便直观读取；更改了IRQ输出逻辑，从reg变成wire，新增中间信号irq来记录内部中断请求。
version 7.5 - 2018.12.19 更改了写CTRL的逻辑，不允许写入32~4位。
*/
`timescale 1ns / 1ps
`define IDLE 0
`define LOAD 1
`define CNT 2
`define INT 3

`define CTRL 0
`define PRESET 1
`define COUNT 2

module Timer(Clock,Reset,Addr,WE,WD,RD,IRQ);
	input Clock;
	input Reset;
	input [3:2] Addr;
	input WE;
	input [31:0] WD;
	output [31:0] RD;
	output IRQ;
	
	reg [31:0]regs[2:0];						// 定义timer中的三个内部寄存器
	reg [1:0]state;							// 定义状态记录仪
	reg irq;									// IRQ中间信号
	wire enable,im;							// 从CTRL 寄存器提取出的有效位（只读）
	wire [2:1] type;
	
	initial begin
		regs[`CTRL] = 0;
		regs[`PRESET] = 0;
		regs[`COUNT] = 0;
		state = `IDLE;
		irq = 0;
	end
	
	// RD
	assign RD = (Addr>=0&&Addr<=2)?regs[Addr]:32'hZZZZZZZZ;
	// IRQ
	assign IRQ = irq & im;
	
	// 提取CTRL寄存器中的有效位，方便观察引用
	assign enable = regs[`CTRL][0];
	assign type = regs[`CTRL][2:1];
	assign im  =regs[`CTRL][3];
	
	// 优先级：reset > WE > 内部状态转移
	always @(posedge Clock)begin
		if(Reset)begin											// priority 1
			regs[`CTRL] <= 0;
			regs[`PRESET] <= 0;
			regs[`COUNT] <= 0;
			state <= `IDLE;
			irq <= 0;
		end
		else begin
			if(WE)begin											// priority 2
				if(Addr==0)
					regs[0][3:0] <= WD[3:0];
				else if(Addr==1)
					regs[1] <= WD;
			end
			else begin											// priority 3
				case(state)
					`IDLE:begin									// 此阶段模式0和1拥有一致的行为，合并
						if(enable==1)begin
							irq <= 0;
							state <= `LOAD;
						end
					end
					`LOAD:begin									// 此阶段模式0和1行动一致，合并
						regs[`COUNT] <= regs[`PRESET];
						state <= `CNT;
					end
					`CNT:begin
						if(enable==0)state <= `IDLE;// 暂停计数，立即返回
						else begin								// 分模式讨论
							// mode 0
							if(type==0)begin
								regs[`COUNT] <= regs[`COUNT] - 1;
								if(regs[`COUNT]<=1) begin		// count=1，上升沿时会到达0,因此触发转移到INT模式
									regs[`CTRL][0] <= 0;			// 模式0中，到达0，使能断开
									irq <= 1;
									state <= `INT;
								end
							end
							// mode 1
							else if(type==1)begin
								regs[`COUNT] <= regs[`COUNT] - 1;
								if(regs[`COUNT]<=1) begin		// count=1，上升沿时会到达0,因此触发转移到INT模式
									irq <= 1;
									state <= `INT;
								end
							end
							else state <= `IDLE;
						end
					end
					`INT:begin
						//mode 0
						if(type==0)begin
							state <= `IDLE;
						end
						else if(type==1)begin											// question !!!: 与标准状态转移图不一致，只有这样才能保证“计数器为0后立即加载pre中的值。”
							irq <= 0;
							state <= `IDLE;
						end
						else state <= `IDLE;
					end
				endcase
			end
		end
	end

endmodule
