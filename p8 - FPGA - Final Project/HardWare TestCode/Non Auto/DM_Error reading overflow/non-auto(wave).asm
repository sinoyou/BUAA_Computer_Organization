.macro clear
	ori $1 $0 0
	ori $2 $1 0
	subu $3 $1 $2
	xor $4 $1 $3
	addi $19 $19 1			# verify tool
.end_macro

mtc0 $0 $14

.text
nop # address overflow using lw --- non auto/auto
case16: clear 
li $1 0x80000000
lw $3 -4($1)

nop  # address overflow using lh --- non auto/auto
case17: clear
li $1 0x7fffffff
lh $3 1($1)

nop # address overflow using lhu --- non auto/auto
case18: clear 
li $1 0x80000000
lhu $3 -2($1)

nop # address overflow using lw --- non auto/auto
case19:clear 
li $1 0x80000000
lb $3 -1($1)

nop  # address overflow using lw --- non auto/auto
case20: clear
li $1 0x7fffffff
lbu $3 1($1)