# for��do-whileѭ�����ģ��

# for-loop type 
.eqv n, $s7
.eqv m, $s6
function1_begin:
	# other operations #
	# start of for loop  #
	li $s0, 1							# i = 1
	function1_loop1_begin:
		bgt $s0, n, function1_loop1_end			# i <= n ?
		nop
		# other operations in layer 1 #
		li $s1, 1						# j = 1, ! j��i�Ƿֲ��ϵ����ʼ��ʱ���Ƶ�Ȳ�ͬ�����ɺϲ���
		function1_loop11_begin:
			bgt $s1, m, function1_loop11_end		# j<=m?
			nop
			# function begin #
			# 	             #
			# function end    #
			addi $s1, $s1, 1				# j++
			j function1_loop11_begin			# back
			nop
		function1_loop11_end:
		# other operations in layer 1 #
		addi $s0, $s0, 1					# i++
		j function1_loop1_begin				# back
		nop
	function1_loop1_end:
	# other operations #
function1_end:

# do-while type loop, �ر�������ֻ���ڲ��к��Ĳ����Ķ���ѭ����
function2_begin:
	# other operations #
	move $s0, $zero 						# i = 0
	move $s1, $zero						# j = 0
	loop_begin:
		# function begin #
		# 	             #
		# function end    #
		addi $s1, $s1, 1					# j++
		bne $s1, m, loop_begin				# j <= m?
		nop
		move $s1, $zero 					# reset j to 0, �ڲ��Ѿ���������Ҫ���á�
		
		add $s0, $s0, 1					# i++
		bne $s0, n, loop_begin				# i <= n?
		nop						# ���ѭ������
function2_end: