.macro lii (%tar, %hi, %lo)
	lui %tar, %hi
	ori %tar, %tar, %lo
.end_macro

ori $1 $0 512
ori $2 $0 2048
ori $3 $0 1024

# sw
lii $20 0x1234 0x5678
sw $20 -8($3)
lii  $21 0xaabb 0xccdd
sw $21 -4($3)
lii $22 0x8765 0x4321
sw $22 0($3)
lii $23 0xddcc 0xbbaa
sw $23 4($3)

# sh
lii $20 0xaabb 0xccdd
sh $20 -2($2)
lii  $21 0xddcc 0xbbaa
sh $21 -4($2)
lii $22 0xaabb 0xccdd
sh $22 2($2)
lii $23 0xddcc 0xbbaa
sh $23 4($2)

# sb
lii $20 0x1234 0x5678
sb $20 -1($1)
lii $21 0xaabb 0xccdd
sb $21 -2($1)
lii $22 0x8765 0x4321
sb $22 -3($1)
lii $23 0xddcc 0xbbaa
sb $23 -4($1)
sb $20 1($1)
sb $21 2($1)
sb $22 3($1)
sb $23 4($1)

#lw
ori $1 $0 512
ori $2 $0 2048
ori $3 $0 1023

lw $4 -7($3)
lw $5 -3($3)
lw $6 1($3)
lw $7 5($3)

#lh
lh $8 1($3)
lh $9 3($3)
lh $10 -1($3)
lh $11 -3($3)

#lhu
lhu $8 1($3)
lhu $9 3($3)
lhu $10 -1($3)
lhu $11 -3($3)

#lb
ori $3 $0 1024
lb $12 0($3)
lb $13 1($3)
lb $14 2($3)
lb $15 3($3)
lb $16 -1($3)
lb $17 -2($3)
lb $18 -3($3)
lb $19 -4($3)

#lbu
lbu $12 0($3)
lbu $13 1($3)
lbu $14 2($3)
lbu $15 3($3)
lbu $16 -1($3)
lbu $17 -2($3)
lbu $18 -3($3)
lbu $19 -4($3)