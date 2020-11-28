.macro lii (%tar, %hi, %lo)
	lui %tar, %hi
	ori %tar, %tar, %lo
.end_macro

# slt
lii $1 0xffff 0xfff0
lii $2 0x0000 1092
slt $3 $1 $2
slt $4 $2 $1
lii $5 0xffff 0xffff
slt $6 $1 $5
slt $7 $5 $1
lui $8 0x000f
slt $9 $2 $8
slt $0 $2 $8			# useless
slt $10 $2 $0

# sltu
lii $1 0xffff 0xfff0
lii $2 0x0000 1092
sltu $3 $1 $2
sltu $4 $2 $1
lii $5 0xffff 0xffff
sltu $6 $1 $5
sltu $7 $5 $1
lui $8 0x000f
sltu $9 $2 $8
sltu $0 $2 $8			# useless
sltu $10 $2 $0