.macro clear
	ori $1 $0 0
	ori $2 $1 0
	subu $3 $1 $2
	xor $4 $1 $3
	addi $19 $19 1			# verify tool
.end_macro

.text
mtc0 $0 $14
nop # address overflow using sw --- non auto/auto
case25: clear 
li $1 0x80000000
sw $1 -6000($1)

nop # address overflow using sh --- non auto/auto
case26: clear 
li $1 0x7fffffff
sh $1 5999($1)

nop # address overflow using sb --- non auto/auto
case27: clear 
li $1 0x80000009
sb $1 -100($1)