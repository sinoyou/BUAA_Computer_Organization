# 外设虚拟地址起始位
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

# 计时器preset值（随频率变化）
.eqv cnt 10000000


# read value of switch
.macro read_switch %a %b
	lw %a switch+0
	lw %b switch+4
.end_macro

# read value of user key
.macro read_key %t
	lw %t key+0
.end_macro

# write uart data
.macro write_uart %t
	uart_wait_loop:
	lw $t8 uart+16			# check lsr THRE
	li $t9 0x20			
	and $t8 $t9 $t8
	beq $t8 $t9 write_accept		# if write ok now?
	nop
	j uart_wait_loop			# if not, wait in infinte loop
	nop
	write_accept:
	sw %t uart+0
.end_macro

# write display data
.macro write_display %a %b
sw %a display+0
sw %b display+4
.end_macro

# write led32 
.macro write_led %t
sw %t led+0
.end_macro

