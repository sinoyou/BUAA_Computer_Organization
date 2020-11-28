# 新增感悟：循环时内层循环考虑 j 复位，因此建议i，j，k不同时定义。
# 函数中所有的内容在begin和end之间。
# 函数对s寄存器的恢复问题：紧贴begin，尾靠end（中间最多允许存在jr和nop语句）。

# s7: the size of matrix n
# s6: the address of matrix1
# s5: the address of matrix 2
# s4: the address of multi
.data 
matrix1: .space 400
matrix2: .space 400
multi: .space 400
stack: .space 100
space: .asciiz " "
enter: .asciiz "\n"

.text

main_begin:
	# initial
	la $sp, stack
	addi $sp, $sp, 100
	la $s6, matrix1
	la $s5, matrix2
	la $s4, multi
	
	# scanf n
	li $v0, 5
	syscall
	move $s7, $v0
	
	# input matrix 1
	la $a0, matrix1
	jal input_matrix_begin
	nop
	
	#input matrix 2
	la $a0, matrix2
	jal input_matrix_begin
	nop
	
	# matrix multi
	jal matrix_multi_begin
	nop
	
	# output
	jal output_begin
	nop
	
	# return 0
	li $v0, 10
	syscall
main_end:

# a0: the beginning address of input array
input_matrix_begin:
	# int i=1;
	li $t1, 1
	
	input_loop_1_begin:
		# judge the condition
		sle $t8, $t1, $s7
		beqz $t8, input_loop_1_end
		
		# !!!attention : i and j must be seperately defined or j can not return to 1 when i++;
		# int j = 1;	
		li $t2, 1
		input_loop_2_begin:
			# judge the condition
			sle $t9, $t2, $s7
			beqz $t9, input_loop_2_end
			
			# scanf a[i][j]
			li $v0, 5
			syscall
			move $t3, $v0
			
			#calculate the address of input value
			mult $s7, $t1
			mflo $t4
			add $t4, $t4, $t2
			mul $t4, $t4, 4
			add $t4, $t4, $a0 # set t4 to the address of input data
		
			# store the value 
			sw $t3, 0($t4)
			
			# j++ and back
			addi $t2, $t2, 1
			j input_loop_2_begin
			nop
		input_loop_2_end:
		
		addi $t1, $t1, 1
		j input_loop_1_begin
		nop
	input_loop_1_end:
	
	# return 
	jr $ra
	nop
input_matrix_end:


# a0: the corresponding row of matrix
# a1: the corresponding column of matrix
# v0: the value of multi[a0][a1]
vector_dot_begin:
	# save the value of s0
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	# int i = 1, s0 = 0
	li $t1, 1
	li $s0, 0
	
	vector_loop_1_begin:
		# judge the condition
		sle $t2, $t1, $s7
		beqz $t2, vector_loop_1_end
		nop
		
		# calculate address of matrix1[a0][i] and matrix[i][a1]
		mult $a0, $s7
		mflo $t3
		add $t3, $t3, $t1
		mul $t3, $t3, 4
		add $t3, $t3, $s6 # set t3 to the first address
		
		
		mult $t1, $s7
		mflo $t4
		add $t4, $t4, $a1
		mul $t4, $t4, 4
		add $t4, $t4, $s5 # set t4 to the second address
		
		# read value and sum up
		lw $t5, 0($t3)
		lw $t6, 0($t4)
		mult $t5, $t6
		mflo $t7
		add $s0, $s0, $t7
		
		# i++ and back
		addi $t1, $t1, 1
		j vector_loop_1_begin
		nop
	vector_loop_1_end:
	
	# copy result to the v0 
	move $v0, $s0
	
	# recover the value of s0 and return 
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	nop
vector_dot_end:


matrix_multi_begin:
	# int i= 1;
	li $s0, 1
	
	multi_loop_1_begin:
		# judge the condition
		sle $t8, $s0, $s7
		beqz $t8, multi_loop_1_end
		
		# int j =1;
		li $s1, 1
		multi_loop_2_begin:
			# judge the condition
			sle $t9, $s1, $s7
			beqz $t9, multi_loop_2_end
			
			# call vector dot multiplication
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			
			move $a0, $s0
			move $a1, $s1
			jal vector_dot_begin
			nop
			
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			
			#calculate the address of input value
			mult $s7, $s0
			mflo $t4
			add $t4, $t4, $s1
			mul $t4, $t4, 4
			add $t4, $t4, $s4 # set t4 to the address of multi data
			
			# store the value
			sw $v0, 0($t4)
			
			# j++ and back
			addi $s1, $s1, 1
			j multi_loop_2_begin
			nop
		multi_loop_2_end:
		
		addi $s0, $s0, 1
		j multi_loop_1_begin
		nop
	multi_loop_1_end:
	
	# return 
	jr $ra
	nop
matrix_multi_end:


output_begin:
	# int i=1;
	li $t1, 1
	
	output_loop_1_begin:
		#judge the condition
		sle $t8, $t1, $s7
		beqz $t8, output_loop_1_end
		nop
		
		# int j = 1
		li $t2, 1
		output_loop_2_begin:
			# judge the condtion
			sle $t9, $t2, $s7
			beqz $t9, output_loop_2_end
			nop
			
			# calculate the address of corresponding value
			mult $t1, $s7
			mflo $t3
			add $t3, $t3, $t2
			mul $t3, $t3, 4
			add $t3, $t3, $s4 # set t3 to the address
			
			# read value and output
			lw $a0, 0($t3)
			li $v0, 1
			syscall
			
			# output sapce ' '
			la $a0, space
			li $v0, 4
			syscall
			
			# j++
			addi $t2, $t2, 1
			j output_loop_2_begin
			nop
		output_loop_2_end:
		
		#print enter '\n'
		la $a0, enter
		li $v0, 4
		syscall
		
		# i++
		addi $t1, $t1, 1
		j output_loop_1_begin
		nop
	output_loop_1_end:
	
	jr $ra
	nop
output_end:
