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
nop # not align 4 in IFU using jalr --- non auto
case1:clear 
li $1 0x0000302e				# need to be fixed
jalr $4 $1
addi $4 $4 1
addi $4 $4 2
label1: addi $4 $4 4
addi $4 $4 8

nop # not align 4 in IFU using jr --- non auto
case2:clear 
li $1 0x00003059				# need to be fixed
jr $1
nop
label2: addi $4 $4 2
addi $4 $4 4

nop # out of range in IFU using jalr --- non  auto
case3:clear 
li $1 0x00005000
jalr $4 $1
nop
addi $10 $0 10011
