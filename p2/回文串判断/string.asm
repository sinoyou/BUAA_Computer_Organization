# 实现思路：栈
# s7: n
# s0: n%2
#s1: n/2
.data
stack: .space 100

.text
main_bagin:
	# initial
	la $sp, stack
	addi $sp, $sp, 100
	
	# read n
	li $v0, 5
	syscall
	move $s7, $v0
	
	# n%2, n/2
	li $t0, 2
	div $s7,$t0
	mfhi $s0
	mflo $s1
	
	# input the first n/2 chars
	li $t0, 1
	for_1_begin:
	 	# judge the condition
	 	sle $t1, $t0, $s1
	 	beqz $t1, for_1_end
	 	nop
	 	
	 	# read char
	 	li $v0, 12
	 	syscall
	 	sw $v0, 0($sp)
	 	addi $sp, $sp, -4
	 	
	 	# i++ and back
	 	 addi $t0, $t0, 1
		 j for_1_begin
		 nop
	  for_1_end: 
	  
	  # filter the immediate value if n%2 = 1
	  beqz $s0, filter_end
	  nop
	  filter_begin:
	  	li $v0, 12
	  	syscall
	  filter_end:
	  
	  # read left n/2 chars and check 'huiwen' condition
	  move $t0, $s1
	  for_2_begin:
	  	# judge the condition
	  	sge $t1, $t0, 1
	  	beqz $t1, for_2_end
	  	nop
	  	
	  	# read char
	  	li $v0, 12
	  	syscall
	  	
	  	# load stored char in the stack
	  	addi $sp, $sp, 4
	  	lw $t2, 0($sp)
	  	
	  	# if v0 != t2, then print 0 and exit
	  	bne $t2, $v0, fail
	  	nop
	  
	  	addi $t0, $t0, -1
	  	j for_2_begin
	  	nop
	  for_2_end:
	  
	  # insist on the last, print yes
	  li $a0, 1
	  li $v0, 1
	  syscall
	  
	  li $v0, 10
	  syscall
main_end:

fail:
	li $a0, 0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall