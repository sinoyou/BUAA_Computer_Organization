.text
# calr
add $1 $2 $3
addu $1 $2 $3
sub $1 $2 $3
subu $1 $2 $3
sll $1 $2 0
srl $1 $2 0
sra $1 $2 0
sllv $1 $2 $3
srlv $1 $2 $3
srav $1 $2 $3
and $1 $2 $3
or $1 $2 $3
xor $1 $2 $3
nor $1 $2 $3
slt $1 $2 $3
sltu $1 $2 $3
mult $1 $2
multu $1 $2
div $1 $2
divu $1 $2
mthi $1
mtlo $1
mfhi $1
mflo $1

# cali
addi $1 $2 0
addiu $1 $2 0
andi $1 $2 0
ori $1 $2 0
xori $1 $2 0
lui $1 0
slti $1 $2 0
sltiu $1 $2 0

# ld
lw $1 0($2)
lb $1 0($2)
lbu $1 0($2)
lh $1 0($2)
lhu $1 0($2)

# st
sw $1 0($2)
sh $1 0($2)
sb $1 0($2)

# branch
beq $1 $2 label_beq
nop
label_beq:
bne $1 $2 label_bne
nop
label_bne:
blez $1 label_blez
nop
label_blez:
bgtz $1 label_bgtz
nop
label_bgtz:
bltz $1 label_bltz
nop
label_bltz:
bgez $1 label_bgez
nop
label_bgez:

# cp0
mfc0 $1 $14
mtc0 $1 $14
eret

# j
j label1
nop
label1:
jal label2
nop
jr $ra
nop
label2:
jalr $1 $ra
