# Èí¼þbugÐÞ¸´¼ÇÂ¼
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
jal calc
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

calc: nop
read_switch $s3 $s4			# $s0 $s1 $s2 are occupied

li $t0 0x01				# add, overflow exception support
bne $t0 $s0 add_end
nop
add $t0 $s3 $s4
slti $t1 $t0 0
write_display $t0 $t1
write_led $t0
add_end:

li $t0 0x02
bne $t0 $s0 sub_end			# sub, overflow exceotion support
nop
sub $t0 $s3 $s4
slti $t1 $t0 0
write_display $t0 $t1
write_led $t0
sub_end:

li $t0 0x04
bne $t0 $s0 and_end			# and
nop
and $t0 $s3 $s4
write_display $t0 $0
write_led $t0
and_end:

li $t0 0x08
bne $t0 $s0 or_end			# or
nop
or $t0 $s3 $s4
write_display $t0 $0
write_led $t0
or_end:

li $t0 0x10
bne $t0 $s0 xor_end			# xor
nop
xor $t0 $s3 $s4
write_display $t0 $0
write_led $t0
xor_end:

li $t0 0x20
bne $t0 $s0 srav_end			# srav
nop
srav $t0 $s3 $s4
slti $t1 $t0 0
write_display $t0 $t1
write_led $t0
srav_end:

li $t0 0x40
bne $t0 $s0 slt_end			# slt
nop
slt $t0 $s3 $s4
write_display $t0 $0
write_led $t0
slt_end:

li $t0 0x80
bne $t0 $s0 sltu_end			# sltu
nop
sltu $t0 $s3 $s4
write_display $t0 $0
write_led $t0
sltu_end:

jr $ra
nop

