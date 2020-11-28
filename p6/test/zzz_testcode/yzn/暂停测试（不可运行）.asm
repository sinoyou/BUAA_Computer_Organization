lw $1, 0($2)
sub $2, $1, $2

lh $2, 0($3)
ori $3, $2, 1

lb $1, 0($2)
lw $2, 0($1)

lhu $1, 0($2)
sh $2, 0($1)

lbu $1, 0($2)
sw $1, 0($0)

lw $1, 0($0)
beq $2,$1,label

lw $1, 0($0)
jr $1

lw $1,0($0)
jalr $ra $1

addu $1,$2,$3
beq $1,$2,label

ori $1,$0,100
bgtz $1,label

addu $1,$2,$3
jr $1

lui $1,0xf
jr $1

srav $1 $2 $3
jalr $ra $1

xori $1 $0 0
jalr $ra $1

lbu $1 0($1)
nop
bne $1,$2,label

lhu $1 0($1)
nop
jr $1

lb $1 0($1)
nop
jalr $1

mult $1 $2
mfhi $3

div $1 $2
mtlo $3

mtlo $1
mflo $2

label: