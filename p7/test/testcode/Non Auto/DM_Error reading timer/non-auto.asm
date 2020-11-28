.text
.macro clear
	ori $1 $0 0
	ori $2 $1 0
	subu $3 $1 $2
	xor $4 $1 $3
	addi $19 $19 1			# verify tool
.end_macro
mtc0 $0 $14

nop # using lh reading timer --- non auto
case7:clear 
li $1 0x00007f1a
lh $3 0($1)
addi $4 $0 1

nop # using lhu reading timer --- non auto
case8:clear 
li $1 0x00007f00
lhu $3 0($1)
addi $4 $0 1

nop # using lb reading timer --- non auto
case9:clear 
li $1 0x00007f0b
lb $3 0($1)
addi $4 $0 1

nop # using lbu reading timer  --- non auto
case10:clear 
li $1 0x00007f1b
lbu $3 0($1)
addi $4 $0 1