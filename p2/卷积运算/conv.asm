# 极容易犯的错误：在计算矩阵地址时，对于行计算，乘的是列数（不是行数）
# s2: m1
# s3: n1
# s4: m2
# s5: n2
# s6: m1 - m2 +1
# s7: n1 - n2 +1

.data
matrix: .space 1000
cell: .space 1000
conv: .space 1000
stack: .space 400
space: .asciiz " "
enter: .asciiz "\n"

.text

main_begin:
	# initial
	la $sp, stack
	addi $sp, $sp, 400
	
	# read m1,n1,m2,n2
	li $v0, 5
	syscall
	move $s2, $v0 # set s2 to m1
	li $v0, 5
	syscall
	move $s3, $v0 # set s3 to n1
	li $v0, 5
	syscall
	move $s4, $v0 # set s4 to m2
	li $v0, 5
	syscall
	move $s5, $v0 # set s5 to n2
	
	# calculate the shape of final conv matrix
	sub $s6, $s2, $s4
	addi $s6, $s6, 1 # set s6 to m1 - m2 +1
	sub $s7, $s3, $s5
	addi $s7, $s7, 1 # set s7 to n1 - n2 + 1
	
	# input matrix array
	la $a0, matrix
	move $a1, $s2
	move $a2, $s3
	jal input_begin
	nop
	
	# input cell array
	la $a0, cell
	move $a1, $s4
	move $a2, $s5
	jal input_begin
	nop
	
	# for(i = 1;i<=m1-m2+1;i++) , for(j = 1; j<= n1 - n2 +1;j++)
	# int i = 1
	li $t0, 1
	main_loop_1_begin:
		# i <= m1-m2+1?
		sle $t2, $t0, $s6
		beqz $t2, main_loop_1_end
		nop
		
		# int j = 1
		li $t1, 1
		main_loop_2_begin:
			# j <= n1 - n2 + 1?
			sle $t3, $t1, $s7
			beqz $t3, main_loop_2_end
			nop
			
			# call conv calculation
			# backup
			addi $sp, $sp, -12
			sw $t0, 0($sp)
			sw $t1, 4($sp)
			sw $ra, 8($sp)
			
			move $a0, $t0
			move $a1, $t1
			jal conv_calc_begin
			nop
			move $t4, $v0 # save return value
			
			# recover
			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $ra, 8($sp)
			addi $sp, $sp, 12	
					
			# calculate relation address of conv[i][j]
			move $t5, $t0 # row
			mul $t5, $t5, $s7 
			add $t5, $t5, $t1 # column
			mul $t5, $t5, 4
			
			# conv[i][j] = value  = t4
			sw $t4, conv($t5)
			
			# j++
			addi $t1, $t1, 1
			j main_loop_2_begin
			nop 
		main_loop_2_end:
	
		# i++
		addi $t0, $t0, 1
		j main_loop_1_begin
		nop
	main_loop_1_end:
	
	jal output_begin
	nop
	
	# return 0
	li $v0, 10
	syscall
main_end:

# a0: the address of input array
# a1: row limit
# a2: column limit
input_begin:
	# int i = 1
	li $t0, 1
	input_loop_1_begin:
		# judge the condition
		sle $t2, $t0, $a1
		beqz $t2, input_loop_1_end
		nop
		
		# int j = 1
		li $t1, 1
		input_loop_2_begin:
			# judge the condition
			sle $t3, $t1, $a2
			beqz $t3, input_loop_2_end
			nop
			
			# calculate the address of input data
			move $t4, $t0 # row
			mul $t4, $t4, $a2 
			add $t4, $t4, $t1 #column
			mul $t4, $t4, 4
			add $t4, $t4, $a0 # set t4 to the address
			
			# input and store
			li $v0, 5
			syscall
			sw $v0, 0($t4)
			
			
			# j++ and back
			addi $t1, $t1, 1
			j input_loop_2_begin
			nop
		input_loop_2_end:
		
		# i++ and back
		addi $t0, $t0, 1
		j input_loop_1_begin
		nop
	input_loop_1_end:
	jr $ra
	nop
input_end:

# a0: row of conv array (as well as th begin of part-matrix in calculation)
# a1: column of conv array (as well as the begin of part-matrix in calculation)
conv_calc_begin:
	# int sum = 0 
	li $s0, 0
	
	# for(i=1;i<=m2;i++),for(j=1;j<=n2;j++)
	# int i = 1
	li $t0, 1
	conv_loop_1_begin:
		# i<=m2?
		sle $t2, $t0, $s4
		beqz $t2, conv_loop_1_end
		nop
		
		# int j = 1
		li $t1, 1
		conv_loop_2_begin:
			# j <= n2?
			sle $t3, $t1, $s5
			beqz $t3, conv_loop_2_end
			nop
			
			# get value of matrix[a0+i-1][a1+j-1]
			move $t4, $a0 # row
			add $t4, $t4, $t0
			addi $t4, $t4, -1
			mul $t4, $t4, $s3 
			add $t4, $t4, $a1 # column
			add $t4, $t4, $t1
			addi $t4, $t4, -1
			mul $t4, $t4, 4 # expand to bytes
			lw $t4, matrix($t4) # set t4 to matrix[a0+i-1][a1+j-1]
			
			# get value of cell[i][j]
			move $t5, $t0 # row
			mul $t5, $t5, $s5
			add $t5, $t5, $t1 # column
			mul $t5, $t5, 4 # expand to bytes
			lw $t5, cell($t5) # set t5 to cell[i][j]
			
			mul $t6, $t4, $t5
			add $s0, $s0, $t6 # sum += value
			
			# j++ and back
			addi $t1, $t1, 1
			j conv_loop_2_begin
			nop
		conv_loop_2_end:
		
		# i++ and back
		addi $t0, $t0, 1
		j conv_loop_1_begin
		nop
	conv_loop_1_end:
	
	move $v0, $s0
	jr $ra
	nop
conv_calc_end:


output_begin:
	# for(i = 1;i<=m1-m2+1;i++) , for(j = 1; j<= n1 - n2 +1;j++)
	# int i = 1
	li $t0, 1
	output_loop_1_begin:
		# i <= m1-m2+1?
		sle $t2, $t0, $s6
		# sle $t2, $t0, $s2 # debug
		beqz $t2, output_loop_1_end
		nop
		
		# int j = 1
		li $t1, 1
		output_loop_2_begin:
			# j <= n1 - n2 + 1?
			sle $t3, $t1, $s7
			# sle $t3, $t1, $s3 # debug
			beqz $t3, output_loop_2_end
			nop
					
			# calculate relation address of conv[i][j]
			move $t5, $t0 # row
			mul $t5, $t5, $s7 
			# mul $t5, $t5, $s2 # debug
			add $t5, $t5, $t1 # column
			mul $t5, $t5, 4
			
			# output conv[i][j] and space
			lw $a0, conv($t5)
			li $v0, 1
			syscall
			la $a0, space
			li $v0, 4
			syscall
			
			# j++
			addi $t1, $t1, 1
			j output_loop_2_begin
			nop 
		output_loop_2_end:
		
		# output \n
		la $a0, enter
		li $v0, 4
		syscall
		
		# i++
		addi $t0, $t0, 1
		j output_loop_1_begin
		nop
	output_loop_1_end:
	jr $ra
	nop
output_end:

