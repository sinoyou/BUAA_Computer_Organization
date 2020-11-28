/*
version 8.0 2018.12.26 ����궨��淶�ڴ�������ַ��Χ��������key��switch��led��display�����ĵ�ַ�����жϣ�����ͷǷ���ȡ����ɾ����timer2���쳣�жϣ�Ŀǰδ���uart������
version 8.0 2018.12.27 ������uart���µ��쳣��������ȡԽ�磬���֡��ֽڴ�ȡuart��uart��lsr�Ĵ����Ĵ�ֵ
*/
`timescale 1ns / 1ps
`include "instr_list.v"
`include "head.v"
//`include "IDU.v"
// memory operation verify
module MOV(IR,Addr,MOV_Error);
	input [31:0] IR;
	input [31:0] Addr;
	output MOV_Error;
	
	wire [`irn_size-1:0] irn;
	wire [`irtype_size-1:0]	irtype;
	
	IDU Idu(.IR(IR),.IRN(irn),.IRType(irtype));
	
	// ����������M�η����Ĵ�������
	wire ld_align,ld_device,ld_range;
	wire st_align,st_device,st_onlyread,st_range;
	
	// output : error
	assign MOV_Error = ld_align | ld_range | ld_device | st_align | st_onlyread | st_range | st_device;
	
	// ����ʶ�� 
	// ȡ���쳣-lw-û��4�ֽڶ���	// ȡ���쳣-lh��lhu-û��2�ֽڶ���
	assign ld_align = (irn==`lw && Addr[1:0]!=0) || ((irn==`lh||irn==`lhu) && Addr[0]!=0);
	// ȡ���쳣-ld-����Χdm,timer1,switch,led,display,key
	assign ld_range = (irtype==`ld && ~( (Addr>=`dm_begin			&&Addr<=`dm_end)||
													 (Addr>=`timer_begin    &&Addr<=`timer_end)|| 
													 (Addr>=`uart_begin		&&Addr<=`uart_end)||
													 (Addr>=`switch_begin   &&Addr<=`switch_end)|| 
													 (Addr>=`led_begin      &&Addr<=`led_end)||
													 (Addr>=`display_begin  &&Addr<=`display_end)||
													 (Addr>=`key_begin      &&Addr<=`key_end)));
	// ȡ���쳣-lh-lhu-lb-lbuȡtimer,switch,led,display,key��ֵ
	assign ld_device = ((irn==`lh || irn==`lhu || irn==`lb || irn==`lbu) &&
							((Addr>=`timer_begin   &&Addr<=`timer_end) || 
							 (Addr>=`uart_begin    &&Addr<=`uart_end) ||
							 (Addr>=`switch_begin  &&Addr<=`switch_end) ||
							 (Addr>=`led_begin     &&Addr<=`led_end) ||
							 (Addr>=`display_begin &&Addr<=`display_end) ||
							 (Addr>=`key_begin     &&Addr<=`key_end)
							));
	
	// �����쳣-lw-û��4�ֽڶ���  // �����쳣-sh-û��2�ֽڶ���
	assign st_align = (irn==`sw && Addr[1:0]!=0) || ((irn==`sh) && Addr[0]!=0);
	// �����쳣-st-��timer-count, switch, key, uart-lsr�д�ֵ
	assign st_onlyread = ((irtype==`st) && ( (Addr>=`timer_begin+32'h8  &&Addr<=`timer_begin+32'hb) || 
														  (Addr>=`switch_begin       &&Addr<=`switch_end) ||
														  (Addr>=`key_begin      	  &&Addr<=`key_end) ||
														  (Addr>=`uart_begin+16		  &&Addr<=`uart_begin+19)
														 ));
	// �����쳣-st-����Χdm,timer1��switch��led��display��key
	assign st_range = (irtype==`st && ~( (Addr>=`dm_begin      &&Addr<=`dm_end)||
													 (Addr>=`uart_begin	  &&Addr<=`uart_end)||
													 (Addr>=`timer_begin   &&Addr<=`timer_end)|| 
													 (Addr>=`switch_begin  &&Addr<=`switch_end)||
													 (Addr>=`led_begin	  &&Addr<=`led_end)||
													 (Addr>=`display_begin &&Addr<=`display_end)||
													 (Addr>=`key_begin     &&Addr<=`key_end)
													));
	// �����쳣-sh��sb-��timer,switch,led,display,key�д�ֵ
	assign st_device = ((irn==`sh || irn==`sb) &&
							((Addr>=`timer_begin     &&Addr<=`timer_end)  || 
							 (Addr>=`uart_begin      &&Addr<=`uart_end)	 ||
							 (Addr>=`switch_begin    &&Addr<=`switch_end) ||
							 (Addr>=`led_begin		 &&Addr<=`led_end)	 ||
							 (Addr>=`display_begin	 &&Addr<=`display_end)||
							 (Addr>=`key_begin		 &&Addr<=`key_end)
							 ));							

endmodule
