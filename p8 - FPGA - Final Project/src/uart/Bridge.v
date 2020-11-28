/*
version 7.5 - 2018.12.18 - �޸���HWInt����Ӳ���豸�෴�����⡣
version 8.0 - 2018.12.25 - ɾ����timer2
version 8.0 - 2018.12.25 - ������дʹ�ܵ��ж�������ɾ����PrWe��ȡ����֮��PrBE���棩��������KEY��SWITCH��LED32��DISPLAY4����������ߣ�����UART��
version 8.0 - 2018.12.26 - �޸���bridge���豸���������ַ���ж�����������Ե�ַȡ�����Ե�ַ��������isim������Ҫ�����м���������ֵ��
version 8.0 - 2018.12.27 - ������UART������·�߹滮����ӦCPU�Ķ����жϣ�UART��д��ַ��дʹ�ܣ�д����
*/
`timescale 1ns / 1ps
`include "head.v"
module Bridge(CPUI_PrWe,CPUI_PrBE,CPUI_PrAddr,CPUI_PrWd,
				  CPUO_PrRd,CPUO_HWInt,
				  TIMER1I_Rd,TIMER1I_IRQ,
				  TIMER1O_Addr,TIMER1O_We,TIMER1O_Wd,
				  UARTI_Rd,UARTI_IRQ,
				  UARTO_Addr,UARTO_We_STB,UARTO_Wd,
				  KEYI_Rd,
				  SWITCHI_Rd,
				  SWITCHO_Addr,
				  LED32I_Rd,
				  LED32O_We,LED32O_Wd,
				  DISPLAYI_Rd,
				  DISPLAYO_Addr,DISPLAYO_We,DISPLAYO_Wd
				  );
	
	// ��CPU������������
	input CPUI_PrWe;
	input [3:0] CPUI_PrBE;
	input [31:0] CPUI_PrAddr;
	input [31:0] CPUI_PrWd;
	output [31:0] CPUO_PrRd;
	output [7:2] CPUO_HWInt;
	// ��Timer1������������
	input [31:0] TIMER1I_Rd;
	input TIMER1I_IRQ;
	output [3:2] TIMER1O_Addr;
	output TIMER1O_We;
	output [31:0] TIMER1O_Wd;
	// �봮���豸������������
	input [31:0] UARTI_Rd;
	input UARTI_IRQ;
	output [4:2] UARTO_Addr;
	output UARTO_We_STB;
	output [31:0] UARTO_Wd;
	// �������豸Key������������
	input [31:0] KEYI_Rd;
	// �������豸Switch������������
	input [31:0] SWITCHI_Rd;
	output SWITCHO_Addr;
	// ������豸32LED������������
	input [31:0] LED32I_Rd;
	output LED32O_We;
	output [31:0] LED32O_Wd;
	// ������豸DISPLAY������������
	input [31:0] DISPLAYI_Rd;
	output DISPLAYO_We;
	output DISPLAYO_Addr;
	output [31:0] DISPLAYO_Wd;
	
	// for cpu
	assign CPUO_HWInt[7:2] = {1'b0, 1'b0, 1'b0, UARTI_IRQ, TIMER1I_IRQ};
	assign CPUO_PrRd = (CPUI_PrAddr>=`timer_begin 	&& CPUI_PrAddr<=`timer_end)? 			TIMER1I_Rd:
							 (CPUI_PrAddr>=`uart_begin		&& CPUI_PrAddr<=`uart_end)?			UARTI_Rd:
							 (CPUI_PrAddr>=`switch_begin 	&& CPUI_PrAddr<=`switch_end)? 		SWITCHI_Rd:
							 (CPUI_PrAddr>=`led_begin 		&& CPUI_PrAddr<=`led_end)? 			LED32I_Rd:
							 (CPUI_PrAddr>=`display_begin && CPUI_PrAddr<=`display_end)? 		DISPLAYI_Rd:
							 (CPUI_PrAddr>=`key_begin 		&& CPUI_PrAddr<=`key_end)? 			KEYI_Rd:
							 32'hZZZZZZZZ;
	
	// for timer1
	// ���ƫ��������ַ
	wire [31:0] timer_addr;
	assign timer_addr = CPUI_PrAddr - `timer_begin;
	assign TIMER1O_Addr = timer_addr[3:2];
	assign TIMER1O_We =  CPUI_PrAddr[31:0]>=`timer_begin && CPUI_PrAddr[31:0]<=`timer_end
								&& CPUI_PrBE==4'b1111;
	assign TIMER1O_Wd = CPUI_PrWd;
	
	// for UART
	// ���ƫ��������ַ
	wire [31:0] uart_addr;
	assign uart_addr = (CPUI_PrAddr - `uart_begin);
	assign UARTO_Addr = uart_addr[4:2];
	assign UARTO_We_STB = CPUI_PrAddr[31:0]>=`uart_begin && CPUI_PrAddr[31:0]<=`uart_end
								 && CPUI_PrBE == 4'b1111;
	assign UARTO_Wd = CPUI_PrWd;
	
	// for Switch
	// (�˴��ĵ�ַ��Ҫע�ⲻ����timerһ�����䣬��Ϊ�������ʼ��ַ������) 6'b101100~6'b101111 and 6'b110000~6'b110011
	// assign SWITCHO_Addr = (CPUI_PrAddr[4]==1)?1'b1:1'b0;
	wire [31:0] switch_addr;
	assign switch_addr  = (CPUI_PrAddr - `switch_begin);
	assign SWITCHO_Addr = switch_addr[2];	// ��⣺���ƫ��������ȷ��
	
	// for 32LED
	assign LED32O_We = CPUI_PrAddr[31:0]>=`led_begin && CPUI_PrAddr[31:0]<=`led_end
							 && CPUI_PrBE==4'b1111;
	assign LED32O_Wd = CPUI_PrWd;
	
	// for DISPLAY
	// assign DISPLAYO_Addr = CPUI_PrAddr[2];
	wire [31:0] display_addr;
	assign display_addr = (CPUI_PrAddr - `display_begin);
	assign DISPLAYO_Addr = display_addr[2];
	assign DISPLAYO_We = CPUI_PrAddr[31:0]>=`display_begin && CPUI_PrAddr[31:0]<=`display_end
								&& CPUI_PrBE==4'b1111;
	assign DISPLAYO_Wd = CPUI_PrWd;
	
	// for KEY
	// none output 
	
	

endmodule
