#  感悟：多层递归调用函数禁止产生过多的return，容易造成栈值未恢复问题。建议在begin，end之间再加一层backup，recover层
# debug的错误值溯源法：根据错误值的大小情况，翻看错误值可能被赋予的地方，确定错误源头。（例如t0不可能到0x30??，因此可以考虑是不是stack恢复时恢复成了ra，进而发现sp指针维护不对称。）
# 既维护s，又维护t还是略显麻烦，建议仅使用一种。（一个函数内调用多的话，用s代码量较少）
# lw和sw可以采用lw $t2, label($t1)的基址寻址方式。
# s7: n
.data
stack: .space 200
visit: .space 60
save: .space 60
space: .asciiz " "
enter: .asciiz "\n"

.text
main_begin:
	# initial 
	la $sp, stack
	addi $sp, $sp, 200
	
	# read n
	li $v0, 5
	syscall
	move $s7, $v0
	
	# call dfs to search
	li $a0, 1
	jal dfs_begin
	nop
	
	# return 0
	li $v0, 10
	syscall
	
main_end:


# a0: depth of current layer
dfs_begin:
	# save s register
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	# depth > n ?
	sgt $t0, $a0, $s7
	beqz $t0, dfs_if_1_end
	dfs_if_1_begin:
		# save ra,a0
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		
		# call function
		jal output_begin
		nop
		
		# recover ra, a0
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		addi $sp, $sp, 8
		
		# return
		# attention !!!!: 在递归调用函数中存在多个return时，建议将引向一个，否则容易忘记对s寄存器的恢复。 
		j dfs_loop_1_end
		nop
	dfs_if_1_end:
	
	# for(i=1;i<=n;i++)
	# int i=1;
	li $s0, 1
	dfs_loop_1_begin:
		# judge the condition
		sle $t9, $s0, $s7
		beqz $t9, dfs_loop_1_end
		nop
		
		# get visit[i]
		move $t0, $s0
		mul $t0, $t0, 4
		lw $t1, visit($t0) # set t1 to visit[i]
		
		bnez $t1, dfs_if_2_end
		nop
		#if(!visit[i])
		dfs_if_2_begin:
			# visit[i] = 1;
			li $t2, 1 
			sw $t2, visit($t0)
			
			# save[depth] = i;
			move $t3, $a0
			mul $t3, $t3, 4
			sw $s0, save($t3)
			
			# call deeper dfs
			# save t, ra,a0 register
			addi $sp, $sp, -12
			sw $ra, 0($sp)
			sw $t0, 4($sp)
			sw $a0, 8($sp)
			
			addi $a0, $a0 ,1
			jal dfs_begin
			nop
			
			# recover
			lw $ra, 0($sp)
			lw $t0, 4($sp)
			lw $a0, 8($sp)
			addi $sp, $sp, 12
			
			# visit[i] = 0;
			li $t2,0
			sw $t2, visit($t0)
		dfs_if_2_end:
	
		# i++ and back
		addi $s0, $s0, 1
		j dfs_loop_1_begin
		nop
		
	dfs_loop_1_end:
	
	# recover s register
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	nop
dfs_end:


output_begin:
	# int i = 1;
	li $t0, 1
	
	output_loop_1_begin:
		# judge the condition
		sle $t1, $t0, $s7
		beqz $t1, output_loop_1_end
		nop
		
		# get save[i]
		move $t2, $t0
		mul $t2, $t2, 4
		lw $t2, save($t2) # set t2 to save[i]
		
		# output save[i] and space
		move $a0, $t2
		li $v0, 1
		syscall
		la $a0, space
		li $v0, 4
		syscall
			
		# i++ and back
		addi $t0, $t0, 1
		j output_loop_1_begin
		nop
	output_loop_1_end:
	
	# output enter
	la $a0, enter
	li $v0, 4
	syscall
	
	jr $ra
	nop
output_end:
