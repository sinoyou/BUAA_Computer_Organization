.macro lii (%tar, %hi, %lo)
	lui %tar, %hi
	ori %tar, %tar, %lo
.end_macro
# addi
addi $1 $0 2018
addi $2 $0 -2018
addi $3 $1 -2018
addi $4 $2 2018
addi $5 $1 2018
addi $6 $2 -2018

 # addiu
addiu $1 $0 2018
addiu $2 $0 -2018
addiu $3 $1 -2018
addiu $4 $2 2018
addiu $5 $1 2018
addiu $6 $2 -2018
lii $7 0x7fff 0xffff
addiu $8 $7 100
lii $9 0x8000 0x00ff
addiu $10 $9 -19202