.include "handler.asm"
.text
.macro clear
	ori $1 $0 0
	ori $2 $1 0
	subu $3 $1 $2
	xor $4 $1 $3
	addi $19 $19 1			# verify tool
.end_macro
mtc0 $0 $14

nop # using lh reading uart --- non auto
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

nop # using lbu reading switch  --- non auto
case10:clear 
li $1 0x00007f2c
lbu $3 0($1)
addi $4 $0 1

nop # using lhu reading switch --- non auto
new_case:clear
li $1 0x00007f32
lhu $3 0($1)
addi $4 $0 1

nop # using lb reading led --- non auto
new_case2:clear
li $1 0x00007f34
lb $3 0($1)
addi $4 $0 1

nop# using lbu reading display --- non auto
new_case3:clear
li $1 0x00007f41
lbu $3 0($1)
addi $4 $0 1

nop # using lb reading use keys --- non auto
new_case4:clear
li $1 0x00007f45
lb $3 -2($1)
addi $4 $0 1

