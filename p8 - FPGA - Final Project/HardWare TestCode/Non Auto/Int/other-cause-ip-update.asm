.text
li $1 0x0000c00			# 全局中断使能关闭
mtc0 $1 $12
li $2 0x00007f10
li $3 10
sw $3 4($2)
li $3 0x00000009
sw $3 0($2)
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
mfc0 $t0 $13  ### stop
mfc0 $t1 $13
nop
nop
nop
addi $1 $0 1

.ktext 0x00004180
# shut down timer
li $10 0x0000000b
li $11 0x00007f10
sw $10 0($11)
mfc0 $k0 $12
mfc0 $k1 $13
mfc0 $k0 $14
mtc0 $k0 $14
addi $1 $1 1 
addi $1 $1 1
addi $1 $1 1
addi $1 $1 1
addi $1 $1 1
addi $1 $1 1
addi $1 $1 1
addi $1 $1 1
addi $1 $1 1
addi $1 $1 1
eret
beq $0 $0 labelk
addi $1 $0 1 
labelk:
addi $1 $0 2
