li $1 0x3777761
mtc0 $1 $12
li $3 0x00007f04
li $5 10              # PRESET
sw $5 0($3)
li $6 0x0000000b      # CTRL  Mode:01
li $3 0x00007f00
sw $6 0($3)         # 3020
nop
nop
nop
nop
sw $0 3($0)

loop:
nop
j loop 
nop
#######################3

.ktext 0x4180
mfc0 $7, $14
mfc0 $t9, $13
mfc0 $t8, $12
eret
mtc0 $t9, $14
nop 
nop
eret
sh $2, 42($0)
