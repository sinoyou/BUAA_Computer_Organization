.macro lii (%tar, %hi, %lo)
	lui %tar, %hi
	ori %tar, %tar, %lo
.end_macro

# add
lii $1 0x10a3 0x8180
lii $2 0x40bf 0x1920
add $3 $1 $2
lii $4 0x8abd 0x9108
add $5 $4 $1
add $6 $1 $4
lii $7 0xffff 0xffff
add $8 $4 $7

# addu
lii $1 0x10a3 0x8180
lii $2 0x40bf 0x1920
addu $3 $1 $2
lii $4 0x8abd 0x9108
addu $5 $4 $1
addu $6 $1 $4
addu $7 $4 $3
lii $8 0x7192 0xf91f
lii $9 0x7102 0x9389
lii $10 0x8abd 0x9108
addu $11 $8 $9
addu $12 $10 $10

# subu
ori $1 $0 100
ori $2 $0 101
sub $3 $1 $2
lui $4 0xfff0
ori $5 $0 32
sub $6 $5 $4
lii $7 0xffff 0xfff0
lii $8 0xffff 0xffff
ori $9 $0 1
sub $10 $7 $8
sub $11 $7 $9

# subu
ori $1 $0 100
ori $2 $0 101
subu $3 $1 $2
lui $4 0xfff0
ori $5 $0 32
subu $6 $5 $4
lii $7 0xffff 0xfff0
lii $8 0xffff 0xffff
ori $9 $0 1
subu $10 $7 $8
subu $11 $7 $9
lii $12 0x7102 0xa81b
lii $13 0x81a0 0x0293
subu $14 $12 $13
lii $15 0x8000 0x0000
lii $16 0x7fff 0xffff
subu $17 $15 $16