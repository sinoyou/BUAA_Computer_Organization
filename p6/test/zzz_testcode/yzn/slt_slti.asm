.macro lii (%tar, %hi, %lo)
	lui %tar, %hi
	ori %tar, %tar, %lo
.end_macro

# slti
ori $1 $0 100
slti $2 $1 10000
ori $3 $0 10000
slti $4 $3 100
addi $5 $0 -2
addi $6 $0 -1
slti $7 $5 -1
slti $8 $6 -2
addi $9 $0 -1
slti $10 $9 0x7fff
ori $11 $0 0x7fff
slti $12 $11 -1

# sltiu
ori $1 $0 100
sltiu $2 $1 10000
ori $3 $0 10000
sltiu $4 $3 100
addi $5 $0 -2
addi $6 $0 -1
sltiu $7 $5 -1
sltiu $8 $6 -2
addi $9 $0 -1
sltiu $10 $9 0x7fff
ori $11 $0 0x7fff
sltiu $12 $11 -1