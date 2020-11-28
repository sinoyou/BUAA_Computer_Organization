.include "handler.asm"
.macro clear
	ori $1 $0 0
	ori $2 $1 0
	subu $3 $1 $2
	xor $4 $1 $3
	addi $19 $19 1			# verify tool
.end_macro

.text
mtc0 $0 $12
nop # save timer using sh --- non auto
case23:clear 
li $1 0x00007f04
sh $0 0($1)
addi $1 $0 1 

nop # save uart using sb --- non auto
case24:clear 
li $1 0x00007f15
sb $0 0($1)
addi $1 $0 1

nop # save led using sh --- non auto
new_case:clear
li $1 0x00007f34
sh $0 0($1)
addi $1 $0 1

nop # save led using sb --- non auto
new_case2:clear
li $1 0x00007f35
sb $3 0($1)
addi $1 $0 1

nop # save display using sh --- non auto
new_case3: clear
li $1 0x00007f39
sh $3 -1($1)
addi $1 $0 1

nop # save display using sb --- non auto
new_case4: clear
li $1 0x00007f3c
sh $3 0($1)
addi $1 $0 1

nop # save uart using sh --- non auto
new_case5: clear
li $1 0x00007f10
sh $3 0($1)
addi $1 $0 1

