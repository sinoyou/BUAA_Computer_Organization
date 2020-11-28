# 分支指令检查采用抽查方式进行，考察有效延迟槽中异常指令对中断异常处理的影响。
# 约定：$2是基址承载体
.macro clear
	ori $1 $0 0
	ori $2 $1 0
	subu $3 $1 $2
	xor $4 $1 $3
	addi $19 $19 1			# verify tool
.end_macro

.text
mtc0 $0 $12

# initial for case1&2
li $1 0x87654321
li $2 0x00001000
sw $1 0($2)

case1:
clear
nop # case1: j+ld
li $2 0x00007f02
j label1
lw $1 0($2)
addi $1 $0 100
label1:
addi $1 $0 200

case2:
clear
nop # case2: jal+st --- double write from jal !!!
li $2 0x00007f02
li $3 0x0000ffff
jal label2
sh $3 0($2)
addi $1 $0 100
label2:addi $1 $0 200

case3:
clear
nop # case3: jr+st
li $4 0x000030a0
li $2 0x00005000
li $3 0x0000ffff
jr $4						# need to be fixed
sh $3 0($2)
addi $1 $0 100
label3:addi $1 $0 200

case4:
clear
nop # case4: jal+archi --- double write from jalr !!!
li $4 0x000030d4
li $2 0x7fffffff
jalr $29 $4					# need to be fixed
add $2 $2 $2
addi $1 $0 100
label4:addi $1 $0 200