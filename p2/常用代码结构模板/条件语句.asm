# if-elseif-else��������ģ��

function1_begin:
	# operation register t0, t1, t2, s0, s1, s2
	# ��һ��if��䣺����Ϊ��ȡʽ			 if(t0<=s0 && t1<=s1&&t2<=s2)
	bge $t0, $s0, function1_if1_end
	bge $t1, $s1, function1_if1_end
	bge $t2, $s2, function1_if1_end
	nop
	function1_if1_begin:
		# function part begin #
		#                                #
		# function part end   #
		j function1_else1_end			# ��תָ��ȡ���� ʵ��if-elseif-else �����ص㡣
		nop
	function1_if1_end:
	# �ڶ���if-else��䣺����Ϊ��ȡʽ			if(t0>s0 || t1>s1 || t2>s2)
	bgt $t0, $s0, function1_ifelse1_begin
	bgt $t1, $s1, function1_ifelse1_begin
	bgt $t1, $s1, function1_ifelse1_begin
	nop
	j function1_ifelse1_end				# ��ǰ��������תָ���Чʱ��������������
	nop
	function1_ifelse1_begin:
		# function part begin #
		#   		      #
		# function part end   #
		j function1_else1_end			# ��תָ��ȡ����ʵ�� if-elseif-else �����ص㡣
		nop
	function1_ifelse1_end:
	# ������Ϊelse��䣬����������
	function1_else1_begin:
		# function part begin #
		# 		      #
		# function part end   #
	function1_else1_end:
function1_end: