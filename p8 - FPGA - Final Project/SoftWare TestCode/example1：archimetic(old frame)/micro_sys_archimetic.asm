# 中断设备相应值handler存放位置，便于正常程序读取
.data 0x0400
timer_bp:
.data 0x040c
uart_bp:
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

# read value of data register after interruption
.macro read_uart %t
	lw %t uart_bp+4
.end_macro

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
	sw %t uart+0
.end_macro

# write display data
.macro write_display	%a %b
lw $t8 display+4				# load sign to check error
li $t9 0x8
and $t8 $t8 $t9
or $t8 $t8 %b				# sign[3]==1 -> error
sw %a display+0
sw %b display+4
.end_macro

# write led32 
.macro write_led %t
sw %t led+0
.end_macro

# write error sign
.macro write_error 
li $t8 0x8
sw $t8 display+4
.end_macro

# main fucntion
# part1: initial memory and set debug value on the memory
# part2: read control signal from user keys
# part3: do different jobs and back to part2
# ATTENTION! EACH DEVICE VALUE CAN ONLY READ ONCE IN ONE LOOP
.text 0x3000
main: nop
# part 1
jal init
nop
# jal debug_set
nop
infinite_loop:
# part 2
read_key $s0
# part 3
jal arithmetic
nop
j infinite_loop
nop

# function: initial
# range: 1024(0,4,8), 1036(0,16,20,24), SR set
init: nop
li $t0 0xfc01
mtc0 $t0 $12
sw $0 timer_bp+0
sw $0 timer_bp+4
sw $0 timer_bp+8
sw $0 uart_bp+0
sw $0 uart_bp+16
sw $0 uart_bp+20
sw $0 uart_bp+24
jr $ra
nop

# function: debug set value (simulate device)
# support: switch, key, uart, display(error)
debug_set:nop
# ------ #
li $t0 0x02
li $t1 0x7fffffff
li $t2 0x91029321
sw $t0 key
sw $t1 switch+0
sw $t2 switch+4
jr $ra
nop

# 0x01 -> addu, 0x02 -> subu, 0x04-> and, 0x08 -> or
# 0x10 -> sllv,  0x20 -> srlv, 0x40-> slt,   0x80 -> sltu 
arithmetic: nop
read_switch $s1 $s2
li $t0 0xff
and $s0 $t0 $s0
addu:
	li $t0 0x01
	bne $t0 $s0 addu_end
	nop
	addu $t1 $s1 $s2
	slti $t2 $t1 0
	write_display $t1 $t2
addu_end:
subu:
	li $t0 0x02
	bne $t0 $s0 subu_end
	nop
	subu $t1 $s1 $s2
	slti $t2 $t1 0
	write_display $t1 $t2
subu_end:
and:
	li $t0 0x04
	bne $t0 $s0 and_end
	nop
	and $t1 $s1 $s2
	write_display $t1 $0
and_end:
or:
	li $t0 0x08
	bne $t0 $s0 or_end
	nop
	or $t1 $s1 $s2
	write_display $t1 $0
or_end:
sllv:
	li $t0 0x10
	bne $t0 $s0 sllv_end
	nop
	sllv $t1 $s1 $s2
	write_display $t1 $0
sllv_end:
srlv:
	li $t0 0x20
	bne $t0 $s0 srlv_end
	nop
	srlv $t1 $s1 $s2
	write_display $t1 $0
srlv_end:
slt:
	li $t0 0x40
	bne $t0 $s0 slt_end
	nop
	slt $t1 $s1 $s2
	write_display $t1 $0
slt_end:
sltu:
	li $t0 0x80
	bne $t0 $s0 sltu_end
	nop
	sltu $t1 $s1 $s2
	write_display $t1 $0
sltu_end:
jr $ra
nop

