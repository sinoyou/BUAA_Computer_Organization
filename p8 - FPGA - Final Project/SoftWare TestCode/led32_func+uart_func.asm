.data 0x7f00
timer: 
.data 0x7f10
uart: 
.data 0x7f2c
switch:
.data 0x7f34
led:
.data 0x7f38
display:
.data 0x7f40
key:

.text 0x3000
# display显示器：a寄存器显示数值位，b寄存器低4位显示符号位
.macro display_out %a %b
	sw %a display+0
	sw %b display+4
.end_macro

# led显示器
.macro led_out %a
	sw %a led+0
.end_macro
main_begin:
	# begin of monitor
	jal monitor_switch_begin
	nop
	jal monitor_uart_begin
	nop
	# end of monitor
	
	# begin of process (display and output included)
	xor $t0 $s5 $s6
	led_out $t0
	
	display_out $s7 $0
	# end of process
	
	j main_begin
	nop
main_end:

monitor_switch_begin:
	lw $s6 switch+0
	lw $s5 switch+4
	jr $ra
	nop
monitor_switch_end:

monitor_uart_begin:
	lw $s7 uart+0
	jr $ra
	nop
monitor_uart_end:
