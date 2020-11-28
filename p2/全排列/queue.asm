#  ���򣺶��ݹ���ú�����ֹ���������return���������ջֵδ�ָ����⡣������begin��end֮���ټ�һ��backup��recover��
# debug�Ĵ���ֵ��Դ�������ݴ���ֵ�Ĵ�С�������������ֵ���ܱ�����ĵط���ȷ������Դͷ��������t0�����ܵ�0x30??����˿��Կ����ǲ���stack�ָ�ʱ�ָ�����ra����������spָ��ά�����Գơ���
# ��ά��s����ά��t���������鷳�������ʹ��һ�֡���һ�������ڵ��ö�Ļ�����s���������٣�
# lw��sw���Բ���lw $t2, label($t1)�Ļ�ַѰַ��ʽ��
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
		# attention !!!!: �ڵݹ���ú����д��ڶ��returnʱ�����齫����һ���������������Ƕ�s�Ĵ����Ļָ��� 
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
