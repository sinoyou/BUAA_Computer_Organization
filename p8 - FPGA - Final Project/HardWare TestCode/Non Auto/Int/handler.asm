.ktext 0x00004180
# shut down timer
li $10 0x00000008
li $11 0x00007f10
sw $10 0($11)
mfc0 $k0 $12
mfc0 $k1 $13
mfc0 $k0 $14
mtc0 $k0 $14
eret
beq $0 $0 labelk
addi $1 $0 1 
labelk:
addi $1 $0 2