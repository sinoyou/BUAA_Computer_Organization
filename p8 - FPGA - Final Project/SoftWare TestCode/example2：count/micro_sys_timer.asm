# 软件bug修复记录
# 1、清除timer置位时采用的应是0xfffffffe
# 2、display num -- 应使用addiu防止溢出异常
# 3、异常时，异常位是31位，在使用lui时后面0x8000
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
jal count
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
li $t0 0x10
sw $t0 switch+0
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

count: nop
read_switch $t0 $t1				# read switch input to check change 
beq $t0 $s7 set_end
nop
set_begin:					# switch value change, auto reset
	addu $s7 $t0 $0				# update freeze value
	write_display $s7 $0			# display new initial value
	sw $0 timer+0				# stop timer
	li $t0 cnt
	sw $t0 timer+4				# set preset
	li $t0 0x9
	sw $t0 timer+0				# restart timer
set_end:
li $t0 0x1
and $t0 $t0 $s1					# get timer int state
beq $t0 $0 decrease_end				# timer not stop yet
nop
decrease:
	li $t0 0xfffffffe
	and $s1 $s1 $t0				# clean timer int state
	li $t0 0x9
	sw $t0 timer+0				# restart timer
	lw $t0 display+0				# display number -- 
	beq $t0 $0 display_overflow		# display = 0, no decrease any more
	nop
	addiu $t0 $t0 -1
	display_overflow:
	write_display $t0 $0
decrease_end:
jr $ra
nop

