# attention: 小心add和and的键盘输入失误
# macro : 不仅是其中被操作的寄存器存在被改写可能，同时也要提防传入的寄存器参数和操作的寄存器出现冲突。（因此尽量传入的a型寄存器，或者在编程前划分几个专用t寄存器给macro）
# ra : ra的保存也可以和s一起保存，不过记得栈取放的顺序是相反的。
# pop and push : 一定要完全反着来，push t1 then t2 则 需要 pop t2 then t1 !!! 
# s4: enx
# s5: eny
# s6: n
# s7: m
# s3: cnt(statistic general ways)
.data
map: .space 500
visit: .space 500
stack: .space 1000

# push macro
.macro push (%int)
	addi $sp, $sp, -4
	sw %int, 0($sp)
.end_macro

# pop macro
.macro pop (%int)
	lw %int, 0($sp)
	addi $sp, $sp, 4
.end_macro

# judge access of tarx tary
.macro judge(%x, %y)
	push $t0
	push $t1
	
	li $t0, 1 # define the result
	sge $t1, %x, 1 # x>=1?
	and $t0, $t0, $t1
	sge $t1, %y, 1 # y>=1?
	and $t0, $t0, $t1
	sle $t1, %x, $s6 # x<=n
	and $t0, $t0, $t1
	sle $t1, %y, $s7 # y<=m
	and $t0, $t0, $t1
	
	# access the visit[tarx][tary]
	move $t1, %x
	mul $t1, $t1, $s7
	add $t1, $t1, %y
	mul $t1, $t1, 4
	lw $t1, visit($t1) # set t1 to visit[tarx][tary]
	# t1 = 0?
	seq $t1, $t1, 0
	and $t0, $t0, $t1
	
	# acccess the map[tarx][tary]
	move $t1, %x
	mul $t1, $t1, $s7
	add $t1, $t1, %y
	mul $t1, $t1, 4
	lw $t1, map($t1) # set t1 to map[tarx][tary]	
	# t1 = 0?
	seq $t1, $t1, 0
	and $t0, $t0, $t1
	
	move $v0, $t0
	
	# recover
	pop $t1
	pop $t0
.end_macro

# visit[x][y] = 1
.macro visit_occupy(%x, %y)
	push $t0
	push $t1
	
	# calculate the visit[tarx][tary]
	move $t1, %x
	mul $t1, $t1, $s7
	add $t1, $t1, %y
	mul $t1, $t1, 4
	
	# set visit[tarx][tary] = 1
	li $t0, 1
	sw $t0, visit($t1)
	
	pop $t1
	pop $t0
.end_macro

# visit[x][y] = 0
.macro visit_release(%x, %y)
	push $t0
	push $t1
	
	# calculate the visit[tarx][tary]
	move $t1, %x
	mul $t1, $t1, $s7
	add $t1, $t1, %y
	mul $t1, $t1, 4
	
	# set visit[tarx][tary] = 1
	li $t0, 0
	sw $t0, visit($t1)
	
	pop $t1
	pop $t0
.end_macro

.text
main_begin:
	# initial
	la $sp, stack
	addi $sp, $sp, 1000
	li $s3, 0
	
	# input n m
	li $v0, 5
	syscall
	move $s6, $v0
	
	li $v0, 5
	syscall
	move $s7, $v0
	
	# call input function
	jal input_begin
	nop
	
	# input stx, sty
	li $v0, 5
	syscall
	move $a0, $v0
	
	li $v0, 5
	syscall
	move $a1, $v0
	
	# input enx,eny
	li $v0, 5
	syscall
	move $s4, $v0
	
	li $v0, 5
	syscall
	move $s5, $v0
	
	# call dfs to search
	jal dfs_begin
	nop
	
	# printf cnt
	move $a0, $s3
	li $v0, 1
	syscall
	
	# return 0
	li $v0, 10
	syscall
main_end:


input_begin:
	# int i = 1;
	li $t0, 1
	input_loop_1_begin:
		# i<=n
		sle $t2, $t0, $s6
		beqz $t2, input_loop_1_end
		nop
		
		# int j = 1
		li $t1, 1
		input_loop_2_begin:
		# i<=m
			sle $t3, $t1, $s7
			beqz $t3, input_loop_2_end
			nop
			
			# calculate 'xiangdui' address
			move $t4, $t0 # row
			mul $t4, $t4, $s7 
			add $t4, $t4, $t1 # column
			mul $t4, $t4, 4
			
			# input value
			li $v0, 5
			syscall
			
			# store the value in the map
			sw $v0, map($t4)
		
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

# a0: present x
# a1: present y
dfs_begin:
	dfs_access:
		push $s0
		push $s1
		# s0 = x, s1 = y
		move $s0, $a0
		move $s1, $a1
	
		# visit [x][y] = 1;
		visit_occupy $s0, $s1
	
	# if(x==enx && y== eny) : reach the destination
	li $t0, 1
	seq $t1, $s0, $s4
	and $t0, $t0, $t1
	seq $t1, $s1, $s5
	and $t0, $t0, $t1
	
	beqz $t0, dfs_if_1_end
	nop
	dfs_if_1_begin:
		addi $s3, $s3, 1
		j dfs_leave
		nop
	dfs_if_1_end:

	dfs_else_1_begin:
		# t0 : tarx, t1: tary
		# tarx = x, tary = y-1;
		addi $t0, $s0, -1
		move $t1, $s1
		# right range && not visited && accssible
		move $a0, $t0
		move $a1, $t1
		judge $a0, $a1
		beqz $v0, up_end
		nop
		up_begin:
			push $ra
			
			move $a0, $t0
			move $a1, $t1
			jal dfs_begin
			nop
			
			pop $ra
		up_end:
		
		# tarx = x+1, tary = y;
		move $t0, $s0
		addi $t1, $s1, 1
		# right range && not visited && accssible
		move $a0, $t0
		move $a1, $t1
		judge $a0, $a1
		beqz $v0, right_end
		nop
		right_begin:
			push $ra
			
			move $a0, $t0
			move $a1, $t1
			jal dfs_begin
			nop
			
			pop $ra
		right_end:
		
		# tarx = x,tary = y+1;
		addi $t0, $s0, 1
		move $t1, $s1
		# right range && not visited && accssible
		move $a0, $t0
		move $a1, $t1
		judge $a0, $a1
		beqz $v0, down_end
		nop
		down_begin:
			push $ra
			
			move $a0, $t0
			move $a1, $t1
			jal dfs_begin
			nop
			
			pop $ra
		down_end:
		
		# tarx = x-1, tary = y;
		move $t0, $s0
		addi $t1, $s1, -1
		# right range && not visited && accssible
		move $a0, $t0
		move $a1, $t1
		judge $a0, $a1
		beqz $v0, left_end
		nop
		left_begin:
			push $ra
			
			move $a0, $t0
			move $a1, $t1
			jal dfs_begin
			nop
			
			pop $ra
		left_end:
	dfs_else_1_end:
	
	dfs_leave:
		# visit[x][y] = 0;
		visit_release $s0, $s1
		pop $s1
		pop $s0
		jr $ra
		nop
dfs_end:	
