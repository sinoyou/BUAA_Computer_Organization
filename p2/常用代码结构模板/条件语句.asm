# if-elseif-else语句的样例模板

function1_begin:
	# operation register t0, t1, t2, s0, s1, s2
	# 第一个if语句：条件为合取式			 if(t0<=s0 && t1<=s1&&t2<=s2)
	bge $t0, $s0, function1_if1_end
	bge $t1, $s1, function1_if1_end
	bge $t2, $s2, function1_if1_end
	nop
	function1_if1_begin:
		# function part begin #
		#                                #
		# function part end   #
		j function1_else1_end			# 跳转指令取决于 实际if-elseif-else 语句的特点。
		nop
	function1_if1_end:
	# 第二个if-else语句：条件为析取式			if(t0>s0 || t1>s1 || t2>s2)
	bgt $t0, $s0, function1_ifelse1_begin
	bgt $t1, $s1, function1_ifelse1_begin
	bgt $t1, $s1, function1_ifelse1_begin
	nop
	j function1_ifelse1_end				# 当前文所有跳转指令都无效时，不满足条件。
	nop
	function1_ifelse1_begin:
		# function part begin #
		#   		      #
		# function part end   #
		j function1_else1_end			# 跳转指令取决于实际 if-elseif-else 语句的特点。
		nop
	function1_ifelse1_end:
	# 第三个为else语句，不带有条件
	function1_else1_begin:
		# function part begin #
		# 		      #
		# function part end   #
	function1_else1_end:
function1_end: