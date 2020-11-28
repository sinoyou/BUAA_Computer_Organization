.ktext 0x00004180
mfc0 $k0 $12
mfc0 $k1 $13
mfc0 $5 $14
# judge the condition
li $1 0x00004ffc
bgt $5 $1 range
nop
align:
	mtc0 $5 $14
	eret
	addi $31 $31 1
range:
	li $5 0x00003084
	mtc0 $5 $14
	eret
	addi $31 $31 1
