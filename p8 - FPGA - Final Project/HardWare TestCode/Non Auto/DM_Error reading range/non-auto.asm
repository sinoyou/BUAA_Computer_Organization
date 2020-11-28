.include "handler.asm"
.macro clear
	ori $1 $0 0
	ori $2 $1 0
	subu $3 $1 $2
	xor $4 $1 $3
	addi $19 $19 1			# verify tool
.end_macro

.text
mtc0 $0 $14
nop # reading out of range using lbu --- non auto
case15: clear 
li $1 0x00007f0c
lbu $3 1($1)

nop # reading out of range using lbu --- non auto
case15_extend: clear 
li $1 0x00002000
lw $3 0($1)

nop # reading out of range using lbu --- non auto
case16_new: clear
li $1 0x00007f40
lbu $3 0($1)
lbu $3 1($1)
lbu $3 2($1)
lbu $3 3($1)
lbu $3 4($1)
