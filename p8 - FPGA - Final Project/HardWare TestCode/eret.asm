# basic function
case1:
li $1 0x12345678
mtc0 $1 $12
# mfc0 $2 $15
li $3 0x00003020
mtc0 $3 $14
eret 
addi $4 $0 1
addi $4 $0 2

# eretû���ӳٲۣ������֧��תָ����Ч
case2:
li $5 0x00003034
mtc0 $5 $14
eret
sw $5 0($0)
sw $5 4($0)
li $6 0x0000304c
mtc0 $6 $14
eret
j label2
addi $10 $0 1
addi $10 $0 2
addi $10 $0 4
label2:
addi $10 $10 8

# eret�����ָ�����ͣ
case3:
li $1 0x0000307c
mtc0 $1 $14
nop
nop
mfc0 $2 $14
eret
beq $2 $2 label3_1
addi $1 $0 1
addi $1 $0 2
label3_1:
addi $1 $0 4
label3_2:
addi $1 $0 8

label_loop:
j label_loop
nop