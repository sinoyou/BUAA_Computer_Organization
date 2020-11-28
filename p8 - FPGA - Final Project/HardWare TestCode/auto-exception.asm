.macro clear
	ori $1 $0 0
	ori $2 $1 0
	subu $3 $1 $2
	xor $4 $1 $3
	addi $19 $19 1			# verify tool
.end_macro


.text
# initial
mtc0 $0 $12
nop # not align 4 in DM using lw 
case4:clear 
li $1 100
sw $1 96($0)
lw $3 -3($1)
lw $4 -4($1)

nop # not align 2 in DM using lh
case5:clear 
li $1 0x66668888
sw $1 200($0)
lh $3 201($0)
lh $4 202($0)

nop # not align 2 in DM using lhu
case6:clear 
li $1 0x66668888
sw $1 300($0)
lhu $3 301($0)
lhu $4 302($0)

nop # reading out of range using lw
case11:clear 
li $1 0x00003004
lw $3 0($1)

nop # reading out of range using lh
case12:clear 
li $1 0x00004000
lh $3 -100($1)

nop # reading out of range using lhu
case13:clear 
li $1 0x00004180
lhu $3 10($1)

nop # reading out of range using lb
case14:clear 
li $1 0x00007f00
lb $3 -1($1)

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

nop # address overflow using lb --- non auto/auto
case19:clear 
li $1 0x80000000
lb $3 -1($1)

nop  # address overflow using lbu --- non auto/auto
case20: clear
li $1 0x7fffffff
lbu $3 1($1)

nop # not align 4 in DM using sw
case21: clear 
li $1 0x00002010
sw $1 2($1)

nop # not align 2 in DM using sh
case22:clear 
li $1 0x00000010
sh $1 -3($1)

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


nop # overflow using add
case32: clear 
li $1 0x80000000
add $2 $1 $1

nop  # overflow using add 2
case33: clear
li $1 0x7fffffff
add $2 $1 $1

nop  # overflow using addi
case34: clear
li $1 0x80000000
addi $2 $1 -1

nop  # overflow using addi 2
case35: clear
li $1 0x7fffffff
addi $2 $1 1

nop # overflow using sub
case36: clear 
li $1 0x80000000
li $2 5
sub $3 $1 $2

nop # overflow using sub 2
case37: clear 
li $1 0x7fffffff
li $2 -100
sub $3 $1 $2

labelx:nop
j labelx
nop

.ktext 0x00004180
# verify correctness
add $20 $0 $19
mfc0 $26 $12
mfc0 $25 $13
# goto the next instruction
mfc0 $k0 $14
addi $k1 $k0 4
mtc0 $k1 $14
eret
beq $0 $0 labelk
addi $1 $1 1
labelk:
addi $1 $1 2
