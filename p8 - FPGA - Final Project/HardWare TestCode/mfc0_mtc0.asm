li $1 0x0000fc03
mtc0 $1 $12
li $2 0xffff0000
mtc0 $1 $14
mfc0 $3 $12
mfc0 $4 $13
mfc0 $5 $14

label_loop:
j label_loop
nop