.eqv n $s7						# s7 = n
.data
visit: .space 500						# visit[i]
save: .space 500						# save array for record result
space:.asciiz " "						
enter:.asciiz "\n"

.text
main_begin:
	li $v0, 5						# scanf n
	syscall
	move n, $v0		
	li $a0, 1						# depth = 1	
	jal dfs_begin					# call dfs function
	nop
	li $v0, 10					# return 0
	syscall
main_end:

# a0: depth of layer
dfs_begin:
	addi $sp, $sp, -12				# backup begin
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)					# backup end
	ble $a0, n, dfs_if_end				# if(depth > n)
	dfs_if_begin:
		addi $sp, $sp, -4
		sw $a0, 0($sp)
		jal output_begin				# call output function
		nop
		lw $a0, 0($sp)
		addi $sp, $sp, 4
		j dfs_return				# return
		nop
	dfs_if_end:
	li $s0, 1						# int i = 1
	dfs_loop_begin:
		bgt $s0, n,dfs_loop_end			# i<=n
		sll $s1, $s0, 2				# cal addr of visit
		lw $t0, visit($s1)				# t0 = visit[i]
		bnez $t0, dfs_if2_end			# if(!visit[i])
		dfs_if2_begin:
			li $t1, 1
			sw $t1, visit($s1)			# visit[i] = 1
			sll $t2, $a0, 2			# cal addr
			sw $s0, save($t2)			# save[depth] = i;
			
			addi $sp, $sp, -4
			sw $a0, 0($sp)
			addi $a0, $a0, 1			# a0 ++ = depth ++
			jal dfs_begin			# call dfs function
			lw $a0, 0($sp)
			addi $sp, $sp, 4
			
			sw $zero, visit($s1)		# visit[i] = 0
			
		dfs_if2_end:
		addi $s0, $s0, 1				# i++
		j dfs_loop_begin
		nop
	dfs_loop_end:
	
	dfs_return:
	lw $s0, 0($sp)					# recover begin
	lw $s1, 4($sp)					
	lw $ra, 8($sp)					
	addi $sp, $sp, 12					# recover end
	jr $ra
	nop
dfs_end:

output_begin:
	addi $sp, $sp, -4					# backup begin
	sw $s0, 0($sp)					# backup end
	li $s0, 1						# int i = 1
	output_loop_begin:
		bgt $s0, n, output_loop_end		# i<=n
		nop
		sll $t0, $s0, 2				# cal addr
		lw $a0, save($t0)				# set a0 to save[i]
		li $v0, 1					# printf save[i]
		syscall					
		la $a0, space				# printf space
		li $v0, 4
		syscall
		addi $s0, $s0, 1				# i++
		j output_loop_begin
		nop
	output_loop_end:
	la $a0, enter					# printf \n
	li $v0, 4
	syscall
	lw $s0, 0($sp)					# recover begin				
	addi $sp, $sp, 4					# recover end
	jr $ra
output_end:
