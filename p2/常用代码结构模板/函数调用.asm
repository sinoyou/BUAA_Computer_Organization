# function call code framwork

function1_begin:
	addi $sp, $sp, -16			# default access setup begin
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)				# default access setup end
	
	# main function part begin#
	addi $sp, $sp, -12			# advanced backup begin
	sw $t0, 0($sp)
	sw $a0, 4($sp)				# 调用时备份的内容为t，a，v寄存器，a、v寄存器的值不可由被调用者保存。
	sw $v0, 8($sp)				# advanced backup end
	
	li $a0, 100				# optional : 传参
	move $a1, $s2				# optional：传参
	jal function_x
	nop
	move $t3, $v0				# optional：保存返回值，好习惯
	
	lw $t0, 0($sp)				# recover begin
	lw $a0, 4($sp)
	lw $v0, 8($sp)
	addi $sp, $sp, 12				# recover end
	# main function part end#
	
	move $v0, $s2				# (optional) if return has value
	return:					# 建立return标签，当函数中间部分需要提前return时使用。
	lw $s0, 0($sp)				# default return setup begin
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16				# default return setup end
	jr $ra					# return 
	nop
function1_end: