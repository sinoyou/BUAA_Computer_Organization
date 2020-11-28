# Mode 1 : user key = 0x01 -> when uart input a , store value of switch B into Mem[switchA[10:0]], accompanied by 2 secs led blinks
# Mode 2: user key = 0x02 -> addu calculation Mem[switchb[10:0]] op Mem[switcha[10:0]]
# Mode 2: user key = 0x04 -> nor calculation Mem[switchb[10:0]] op Mem[switcha[10:0]]
.include "head.asm"
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
 jal Function
nop
# part 4
jal error_display
nop
j infinite_loop
nop

# function: initial
# range: SR set
# range: timer->stop, display->0, led->0
# range $gp -> 0, $sp -> 0
init: nop
li $t0 0xfc01
mtc0 $t0 $12
write_display $0 $0
write_led $0 
sw $0 timer+0
sw $0 timer+4
li $gp 0
li $sp 0
jr $ra
nop

# function: debug set value (simulate device)
# support: switch, key, uart, display(error)
debug_set:nop
# ------ #
li $t0 0x12345678
sw $t0 switch+0
li $t0 2047
sw $t0 switch+4
li $t0 0x1
sw $t0 key+0
li $s1 'A'
sll $s1 $s1 8
ori $s1 $s1 0x1
jr $ra
nop

# function: show error on display and led32
# when started, never stop unless reset system
error_display:nop
lui $t0 0x8000
and $t0 $t0 $s2
beq $t0 $0 no_error
nop
error_loop:				# error detected, loop infinitely
li $t0 0x8
write_display $s2 $t0			# output error on the display
j error_loop
nop
no_error:
jr $ra
nop

# fucntion: calc with saving number mode
Function:
	li $t0 0x01
	bne $t0 $s0 Mode1_end
	nop
	Mode1:						# Mode1: store value in calc
	andi $t0 $s1 0x2
	beq $t0 $0 Store_end				# data received!
	li $t0 0xff00
	and $t1 $t0 $s1					# get uart data
	srl $t1 $t1 8
	li $t0 'A'						# correct command!
	bne $t0 $t1 Store_end
	nop
	nop
		Store:
		read_switch $t2 $t3			# read value
		andi $t3 $t3 0x7ff			# only read low 11 bits
		sll $t3 $t3 2				
		sw $t2 0($t3)				# Func1: store value in mem
		li $s3 0					# Func2: initial 2 secs cnt
		li $t0 0xffffffff
		write_led $t0				# led32 turn light
		li $t0 cnt					
		sw $t0 timer+4				# timer preset
		sw $0 timer+0				# stop timer
		li $t0 0x9
		sw $t0 timer+0				# start timer
		li $t0 0xfffffffd				# Func3: s1[uart]=0
		and $s1 $s1 $t0
		Store_end:
	Mode1_end:
	
	li $t0 0x2
	bne $t0 $s0 Mode2_end
	nop
	Mode2:						# Mode2: addu 
	read_switch $t2 $t3				# read value
	sll $t2 $t2 2
	sll $t3 $t3 2
	lw $t2 0($t2)
	lw $t3 0($t3)
	addu $t1 $t2 $t3					# calculate result
	slti $t0 $t1 0					# neg sign
	write_display $t1 $t0				# screen output value
	Mode2_end:
	
	li $t0 0x4
	bne $t0 $s0 Mode3_end
	nop
	Mode3:
	read_switch $t2 $t3				# read value
	sll $t2 $t2 2
	sll $t3 $t3 2
	lw $t2 0($t2)
	lw $t3 0($t3)
	nor $t0 $t2 $t3					# calc result
	write_display $t0 $0
	Mode3_end:
	
	LED_Check:
	li $t0 0x1
	andi $t1 $s1 0x1
	bne $t1 $t0 LED_continue
	nop
	addi $s3 $s3 1					# cnt ++
	bne $s3 2 LED_continue				# if(cnt < 2)
	nop
	write_led $0					# led turn dark
	li $s3 0						# s3 back to 0
	li $t0 0xfffffffe
	and $s1 $s1 $t0					# set s1[timer]=0
	LED_continue:
Function_end:
jr $ra
nop

# update: 当计时器到达0时，不再继续减法溢出

# handler语法规定：
# 1、不允许使用jal，jalr更改ra寄存器值
# 2、独立寄存器仅能使用t0~t7，k0, k1
# 3、sx类寄存器是全局变量，请谨慎使用(目前仅支持$s1中断待处理位、异常位和uart数据位的写入)
# 4、handler只有停止的权利（停止timer），没有启动和改变的权利（启动计时，改写显示内容）
.ktext 0x4180
j backup
nop
backup_back: nop
mfc0 $k0 $13
li $t0 0x7c				# judge interruption or exception
and $t1 $t0 $k0				# exception is not expecetd!
beq $t1 $0 int_handler
nop

exception_handler: nop			# not expected
mfc0 $k1 $14				# read epc
lui $s2 0					# clean s2			
lui $s2 0x8000				# s2[31] = s2[exc] = 1
li $t0 0x7c
and $t0 $t0 $k0				# get exccode[6:2]
sll $t0 $t0 24				# shift excode[6:2] to s2[26:30]
or $s2 $s2 $t0				# s2[26-30] = exccode
or $s2 $s2 $k1				# s2[15-0] = epc			
addi $k1 $k1 4				# skip the instr
mtc0 $k1 $14
j recover_eret
nop

int_handler: nop				
li $t0 0x0400
and $t1 $t0 $k0
beq $t1 $t0 timer_int			# if int from timer
nop
timer_int_back:
li $t0 0x0800
and $t1 $t0 $k0
beq $t1 $t0 uart_int			# if int from uart
nop
uart_int_back:
j recover_eret				# end handler and eret
nop
	unknown_int: nop			# unknown int
	j recover_eret
	nop
	
	timer_int: nop				# timer_int
	timer_set:
	sw $0 timer+0				# stop count
	ori $s1 $s1 0x1				# s1[timer] = 1
	j timer_int_back
	nop
	
	uart_int:	nop				# uart_int
	lw $t0 uart+16				# load lsr to check valid
	li $t1 0x1
	and $t0 $t1 $t0
	# write_display $t0 $0
	bne $t0 $t1 uart_skip			# unvalid data, so skip
	nop
	lw $t0 uart+0				# valid data, store in s1 and s1[uart]=1
	li $t1 0xffff00ff
	and $s1 $s1 $t1				# clean uart rd stored in $s1
	sll $t0 $t0 8
	or $s1 $s1 $t0				# store new uart rd in $s1
	ori $s1 $s1 0x2				# s1[uart] = 1
	# write_display $s1 $0
	uart_skip: 
	j uart_int_back
	nop

# function: back up tx regs
# range: t0~t7
backup: nop
addi $sp $sp 100
sw $t0 0($sp)
sw $t1 -4($sp)
sw $t2 -8($sp)
sw $t3 -12($sp)
sw $t4 -16($sp)
sw $t5 -20($sp)
sw $t6 -24($sp)
sw $t7 -28($sp)
j backup_back
nop

# function: recover tx regs
# range: t0~t7
recover_eret: nop
lw $t0 0($sp)
lw $t1 -4($sp)
lw $t2 -8($sp)
lw $t3 -12($sp)
lw $t4 -16($sp)
lw $t5 -20($sp)
lw $t6 -24($sp)
lw $t7 -28($sp)
addi $sp $sp -100
eret
nop
