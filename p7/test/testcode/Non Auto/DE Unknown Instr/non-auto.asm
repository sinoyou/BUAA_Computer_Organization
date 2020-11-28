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
lwl $1 0($2)
addi $1 $0 1