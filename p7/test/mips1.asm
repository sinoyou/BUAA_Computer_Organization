.ktext 0x00004180
# verify correctness
add $20 $0 $19
mfc0 $26 $12
mfc0 $25 $13
# goto the next instruction
mfc0 $k0 $14
addi $k1 $k0 4
mtc0 $k1 $14
eret
beq $0 $0 labelx
addi $1 $1 1
labelx:
addi $1 $1 2

.text
mtc0 $0 $12
li $1 0x80000000
li $2 0x80000000
beq $0 $0 label
add $3 $1 $1
label:
nop
nop
addi $3 $0 1