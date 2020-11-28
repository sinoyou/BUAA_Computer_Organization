# ��ָ֧������ó�鷽ʽ���У�������Ч�ӳٲ����쳣ָ����ж��쳣������Ӱ�졣
# Լ����$2�ǻ�ַ������
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
nop #case1: beq+ld 
clear
li $2 0x00005001
beq $0 $0 label1
lw $1 0($2)
addi $1 $0 100
label1:
addi $1 $0 200

case2:
nop #case2: bne+ld 
clear
li $2 0x00003001
bne $2 $0 label2
lh $1 0($2)
addi $1 $0 100
label2:
addi $1 $0 200

case3:
nop #case3: bgtz+st
clear
li $4 1
li $2 0x00007f08
li $3 0x87654321
bgtz $4 label3
sw $3 0($2)
addi $1 $0 100
label3:
addi $1 $0 200

case4:
nop #case4: bgez+st
clear
li $1 1
li $2 0x8000000f
li $3 0x87654321
bgez $0 label4
sh $3 -1000($2)
addi $1 $0 100
label4:
addi $1 $0 200

case5:
nop #case5: bltz+archi
clear
li $4 -1
li $2 0x7fffffff
bltz $4 label5
add $2 $2 $2
addi $1 $0 100
label5:
addi $1 $0 200

case6:
nop #6: blez+unknow
clear
blez $0 label6
lwl $1 0($0)
addi $1 $0 100
label6:
addi $1 $0 200

case7:
nop #7: no branch
clear
bne $0 $0 label7
lwl $1 0($0)
addi $1 $0 100
label7:
addi $1 $0 200


.ktext 0x00004180
# Լ����$2�ǻ�ַ������
# counter
addi $18 $0 1
# read cause and sr
mfc0 $k0 $12
mfc0 $k1 $13
li $10 0x80000010
beq $10 $k1 load_error
nop
li $10 0x80000014
beq $10 $k1 store_error
nop
li $10 0x80000030
beq $10 $k1 archi_error
nop
li $10 0x80000028
beq $10 $k1 unknow_error
nop

normal_error:
addi $17 $0 1
mfc0 $k0 $14
addi $k0 $k0 4
mtc0 $k0 $14
eret

load_error:
addi $17 $0 2
li $2 0x00001000
mfc0 $k0 $14
mtc0 $k0 $14
eret

store_error:
addi $17 $0 3
li $2 0x00002000
mfc0 $k0 $14
mtc0 $k0 $14
eret

archi_error:
addi $17 $0 4
mfc0 $k0 $14
li $2 8
mtc0 $k0 $14
eret

unknow_error:
addi $17 $0 5
mfc0 $k0 $14
addi $k0 $k0 4
mtc0 $k0 $14
eret