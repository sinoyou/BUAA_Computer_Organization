# R型指令三个参数的运用，静态查错要点，相似语句复制粘贴时修改注意点(标签，范围，数组名)
# 注意space空间的申请计算方式： 2^((log (max (m, n)) + 1) + 2) ，务必*4因为申请的是子节空间。否则应使用.word 方法
# s7: n1 -- 行数
# s6: m1 -- 列数
# s5: n2 -- 行数
# s4: m2 -- 列数
# s3: n1-n2+1
# s2: m1-m2+1
.data
matrix: .word 0:256
conv: .word 0:256
space: .asciiz " "
enter: .asciiz "\n"
.text
main_begin:
	li $v0, 5					# cin n1
	syscall
	move $s7, $v0
	li $v0, 5					# cin m1
	syscall
	move $s6, $v0 		
	li $v0, 5					# cin n2
	syscall
	move $s5, $v0
	li $v0, 5					#cin m2
	syscall
	move $s4, $v0
	###Function : input matrix###
	li $t0, 1					# int i = 1;
	main_loop11_begin:	
		bgt $t0, $s7, main_loop11_end			# i<=n1?
		nop
		li $t1, 1				# int j = 1;
		main_loop12_begin:
			bgt $t1, $s6, main_loop12_end		# j<=m1
			nop
			li $v0, 5			# scanf("%d",&matrix[i][j])
			syscall
			sll $t3, $t0, 4		# calculate the address
			add $t3, $t3, $t1
			mul $t3, $t3, 4
			sw $v0, matrix($t3)	# matrix[i][j] = input
			addi $t1, $t1, 1		# j++
			j main_loop12_begin
			nop
		main_loop12_end:
		addi $t0, $t0, 1			# i++
		j main_loop11_begin
		nop
	main_loop11_end:
	###Function : input conv###
	li $t0, 1					# int i = 1;
	main_loop21_begin:	
		bgt $t0, $s5, main_loop21_end		# i<=n2?
		nop
		li $t1, 1				# int j = 1;
		main_loop22_begin:
			bgt $t1, $s4, main_loop22_end		# j<=m2
			nop
			li $v0, 5			# scanf("%d",&conv[i][j])
			syscall
			sll $t3, $t0, 4		# calculate the address
			add $t3, $t3, $t1
			mul $t3, $t3, 4
			sw $v0, conv($t3)	# matrix[i][j] = input
			addi $t1, $t1, 1		# j++
			j main_loop22_begin
			nop
		main_loop22_end:
		addi $t0, $t0, 1			# i++
		j main_loop21_begin
		nop
	main_loop21_end:	
	
	###Function: calculate conv value###
	sub $s3, $s7, $s5
	addi $s3, $s3, 1						# n1 - n2 + 1
	sub $s2, $s6, $s4
	addi $s2, $s2, 1						# m1 - m2 + 1
	li $t0, 1							# i = 1
	main_loop_31_begin:
	bgt $t0, $s3, main_loop_31_end				# i<= n1 - n2 + 1
	nop
	li $t1, 1							# j = 1
	main_loop_32_begin:
		bgt $t1, $s2, main_loop_32_end			# j<=m1-m2 + 1
		nop
		### 增强版修改部分：64位乘法的改进
		mtlo $zero 					# int sum_lo = 0 --- to sum up the answer and output
		mthi $zero					# int sum_hi = 0 --- ...
		li $t2, 1						# int k = 1
		main_loop_33_begin:
			bgt $t2, $s5, main_loop_33_end		# k<=n2
			nop
			li $t3, 1					# int l = 1	
			main_loop_34_begin:
				bgt $t3, $s4, main_loop_34_end
				nop
				### core calculation kernal ###
				sll $t4, $t2, 4			# get value of conv[k][l]
				add $t4, $t4, $t3
				sll $t4, $t4, 2
				lw $t5, conv($t4)			# set t5 to conv[k][l]
				
				add $t4, $t0, $t2			# get value of matrix[i+k-1][j+l-1]
				addi $t4, $t4 -1
				sll $t4, $t4, 4
				add $t4, $t4, $t1
				add $t4, $t4, $t3
				addi $t4, $t4, -1
				sll $t4, $t4, 2
				lw $t6, matrix($t4)		# set t6 to matrix[i+k-1][j+l-1]
				
				### 增强版修改部分：64位乘法的改进
				madd $t5, $t6			# hi + lo  = t5 + t6
				### end of core calculation kernal ###
				addi $t3, $t3, 1			# l++
				j main_loop_34_begin
				nop
			main_loop_34_end:
			addi $t2, $t2, 1				# k++
			j main_loop_33_begin
			nop
		main_loop_33_end:
		li $v0, 35					# printf("%d",sum)
		mfhi $a0
		syscall
		li $v0, 35
		mflo $a0
		syscall
		li $v0, 4						# printf(" ")
		la $a0, space
		syscall
		addi $t1, $t1, 1
		j main_loop_32_begin
		nop						# j++
	main_loop_32_end:
	li $v0, 4							# printf("\n")
	la $a0, enter
	syscall
	addi $t0, $t0, 1						# i++
	j main_loop_31_begin
	nop
	main_loop_31_end:
	li $v0, 10						# return 0
	syscall
main_end:
