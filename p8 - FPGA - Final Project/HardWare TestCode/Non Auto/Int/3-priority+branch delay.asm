.text
li $5 0x80000000
li $1 0x0000c01
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
beq $0 $0 labelx
add $5 $5 $5  ### stop
nop
nop
nop
nop
labelx:
addi $1 $0 1

.ktext 0x00004180
# shut down timer
li $10 0x00000001
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
li $5 100
eret
beq $0 $0 labelk
addi $1 $0 1 
labelk:
addi $1 $0 2