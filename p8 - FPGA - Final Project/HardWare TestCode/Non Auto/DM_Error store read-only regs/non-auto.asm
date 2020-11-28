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
nop # save reg count using sw --- non auto
case28: clear 
li $1 0x00007f08
sw $1 0($1)
addi $1 $0 1

nop # save reg count using sh --- non auto
case29: clear 
li $1 0x00007f1a
sh $1 0($1)
addi $1 $0 1

nop # save uart lsr using sw --- non auto
case30: clear 
li $1 0x00007f20
sw $1 0($1)
addi $1 $0 1

nop # save switch using sw ---non auto
new_case: clear
li $1 0x00007f2d
sw $1 -1($1)
addi $1 $0 1

nop # save switch using sh --- non auto
new_case2: clear
li $1 0x00007f30
sh $1 0($1)
addi $1 $0 1

nop # save user key using sw --- non auto
new_case3: clear
li $1 0x00007f40
sw $1 0($1)
addi $1 $0 1
