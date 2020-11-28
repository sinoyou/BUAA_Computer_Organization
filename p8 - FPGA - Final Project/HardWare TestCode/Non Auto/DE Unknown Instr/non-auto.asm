.macro clear
	ori $1 $0 0
	ori $2 $1 0
	subu $3 $1 $2
	xor $4 $1 $3
	addi $19 $19 1			# verify tool
.end_macro

.text
mtc0 $0 $14
nop # unknwon instructions --- non auto
case31: clear 
li $1 0x0000ffff
mult $1 $1
lw $t0 0($0)
mfc0 $1
nop
divu $t9 $t0
addi $1 $0 1
