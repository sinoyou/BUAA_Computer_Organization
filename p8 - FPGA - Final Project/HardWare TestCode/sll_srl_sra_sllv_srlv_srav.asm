.macro lii (%tar, %hi, %lo)
	lui %tar, %hi
	ori %tar, %tar, %lo
.end_macro

# sll
lii $1 0x1234 0x5678
sll $2 $1 0
sll $3 $1 2
sll $4 $1 24

# srl
lii $1 0x8765 0x4321
srl $2 $1 0
srl $3 $1 2
srl $4 $1 24

# sra
lii $1 0x8765 0x4321
sra $2 $1 4
sra $3 $1 31
lii $4 0x1234 0x5678
sra $5 $4 6

# sllv
ori $1 $0 0
lii $2 0x1234 0x5678
sllv $3 $2 $1
ori $4 $0 2
sllv $5 $2 $4
ori $6 $0 24
sllv $7 $2 $6
ori $8 $0 48
sllv $9 $2 $8

# srlv
ori $1 $0 0
lii $2 0x8765 0x4321
srlv $3 $2 $1
ori $4 $0 2
srlv $5 $2 $4
ori $6 $0 24
srlv $7 $2 $6
ori $8 $0 48
srlv $9 $2 $8

# sllv
ori $1 $0 4
lii $2 0x8765 0x4321
srav $3 $2 $1
ori $4 $0 31
srav $5 $2 $4
ori $6 $0 48
srav $7 $2 $6
ori $8 $0 6
lii $9 0x1234 0x5678
srav $10 $9 $8


label_loop:
j label_loop
nop