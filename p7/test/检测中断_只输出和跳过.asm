li $1 0x3777761
mtc0 $1 $12
li $3 0x00007f04
li $5 5              # PRESET
sw $5 0($3)
li $6 0x0000000b      # CTRL  Mode:01
li $3 0x00007f00
sw $6 0($3)         # 3020
#############
addi $1, $1, 0x7543
multu $5, $3
add $0, $2, $4
sub $0, $1, $3
mthi $0
ori $2, $5, 0x5959
srlv $4, $4, $3     # 303c
sltu $3, $0, $4     # 3040
sltu $5, $1, $0     # 3044
lw $3, 2($0)        # 3048
lh $0, 2($0)        # 304c
div $4, $0          # 3050
sh $0, 32($0)       # 3054
addiu $3, $1, 0x67f4
sw $5, 2($0)        # 305c
sub $1, $2, $0      # 3060
multu $4, $3        # 3064
xor $4, $2, $1      # 3068
sllv $4, $0, $5     # 306c
addi $5, $4, 0x4de6
addi $5, $0, 0x2d22
srlv $3, $3, $1
andi $5, $2, 0x6386
add $5, $3, $0
add $2, $1, $1
sub $2, $1, $5
srav $4, $0, $1
add $0, $4, $5
li $3, 0xf8e051f2
lh $2, 52($0)
srav $2, $2, $1
add $2, $5, $5
mtlo $5
divu $3, $3
multu $2, $3
sw $1, 3($0)
div $1, $3
slti $2, $1, 0x777d
sb $0, 52($0)
sltu $3, $0, $1
sw $2, 46($0)
mflo $2
div $4, $4
lbu $4, 25($0)
addi $4, $4, 0x549e
add $3, $3, $4
slti $0, $3, 0x4a05
sub $2, $1, $1
add $3, $2, $1
lh $4, 7($0)
lbu $4, 42($0)
add $2, $0, $4
lb $0, 5($0)
lbu $4, 8($0)
sb $3, 2($0)
andi $4, $0, 0x2249
xori $1, $2, 0x124
sllv $1, $4, $3
lh $5, 43($0)
lbu $1, 42($0)
ori $5, $2, 0x5e17
ori $1, $3, 0x2081
subu $0, $5, $2
lh $2, 40($0)

loop:
nop
j loop 
nop
#######################3

.ktext 0x4180
mfc0 $t9, $14
mfc0 $t8, $13
mfc0 $t8, $12
addiu $t9, $t9, 4
mtc0 $t9, $14
nop 
nop
eret
sh $2, 42($0)
