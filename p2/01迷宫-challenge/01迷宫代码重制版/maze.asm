# core:
# 0.写好C代码，能省很多事情，C代码的简要是mips简要的关键。
# 1.调用函数时函数的书写结构与注释（return怎么写，default setup怎么写）？
# 2.for循环语句结构框架
# 3.if语句（条件全&，条件全|的不同表达结构）
# 4.if-elseif-else语句结构
# name register, not available : s7~s3
.eqv n $s7
.eqv m $s6
.eqv enx $s5
.eqv eny $s4
.eqv cnt $s3

.data
map: .word 0:256

.macro input_int(%x)
	li $v0, 5
	syscall
	move %x, $v0
.end_macro

.text
main_begin:
	input_int(n)				# cin n
	input_int(m)				# cin m
	### function : input map matrix ###
	li $t0, 1					# i = 1
	main_loop_1_begin:
		bgt $t0, n, main_loop_1_end	# i<=n
		nop
		li $t1, 1				# j = 1
		main_loop_2_begin:
			bgt $t1, m, main_loop_2_end	# j<=m
			nop
			li $v0, 5			# cin map[i][j]
			syscall
			sll $t2, $t0, 4		# row cal 
			add $t2, $t2, $t1		# column cal
			sll $t2, $t2, 2		# address cal
			sw $v0, map($t2)		# store data into matrix
			addi $t1, $t1, 1		# j++
			j main_loop_2_begin
			nop
		main_loop_2_end:
		addi $t0, $t0, 1			# i++
		j main_loop_1_begin
		nop
	main_loop_1_end:
	input_int($a0)				# cin stx to a0
	input_int($a1)				# cin sty to a1
	input_int(enx)				# cin enx
	input_int(eny)				# cin eny
	jal dfs_begin				# call dfs function
	nop
	li $v0, 1					# cout cnt
	move $a0, cnt
	syscall
	li $v0, 10				# return 0
	syscall
main_end:

# a0: present x, a1: present y
dfs_begin:
	addi $sp, $sp, -16			# default call setup begin
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)				# default call setup end 
	
	move $s0, $a0				
	move $s1, $a1			
	
	blt $s0, 1, dfs_if_1_end			# x>=1
	blt $s1, 1 dfs_if_1_end			# y>=1
	bgt $s0, n, dfs_if_1_end			# x<=n
	bgt $s1, m, dfs_if_1_end			# y<=m
	sll $s2, $s0, 4				# row cal 
	add $s2, $s2, $s1				# column cal
	sll $s2, $s2, 2 				# address cal
	lw $t1, map($s2)				# set t1 to map[x][y]
	bnez $t1, dfs_if_1_end			# map[x][y] == 0
	nop
	dfs_if_1_begin:				# if(map[x][y] == 0 && x>=1 && y>=1 && x<=n && y<=m)
		bne $s0, enx, dfs_if_11_end	# x == enx
		bne $s1, eny, dfs_if_11_end	# y == eny
		nop
		dfs_if_11_begin:			# if(x==enx&&y==eny)
			addi cnt, cnt, 1		# cnt++
			j dfs_if_11_else_end
			nop
		dfs_if_11_end:
		dfs_if_11_else_begin:		# else
			li $t0, 1
			sw $t0, map($s2)		# map[x][y] = 1
			add $a0, $s0, -1		# dfs(x-1, y)
			add $a1, $s1, $zero
			jal dfs_begin
			nop
			add $a0, $s0, $zero	# dfs(x, y+1)
			add $a1, $s1, 1
			jal dfs_begin
			nop
			add $a0, $s0, 1		# dfs(x+1,y)
			add $a1, $s1, $zero
			jal dfs_begin
			nop
			add $a0, $s0, $zero	# dfs(x, y-1)
			add $a1, $s1, -1
			jal dfs_begin
			nop
			li $t0, 0	
			sw $t0, map($s2)		# map[x][y] = 0
		dfs_if_11_else_end:
	dfs_if_1_end:
	
	lw $s0, 0($sp)				# defualt return setup begin
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16				# default return setup end
	jr $ra
	nop
dfs_end:
