.ktext 0x00004180
# 约定：$2是基址承载体
# counter
addi $18 $0 1
# read cause and sr
mfc0 $k0 $12
mfc0 $k1 $13
li $10 0x80000010
beq $10 $k1 load_error
nop
li $10 0x80000014
beq $10 $k1 store_error
nop
li $10 0x80000030
beq $10 $k1 archi_error
nop
li $10 0x80000028
beq $10 $k1 unknow_error
nop

normal_error:
addi $17 $0 1
mfc0 $k0 $14
addi $k0 $k0 4
mtc0 $k0 $14
eret

load_error:
addi $17 $0 2
li $2 0x00001000
mfc0 $k0 $14
mtc0 $k0 $14
eret

store_error:
addi $17 $0 3
li $2 0x00002000
mfc0 $k0 $14
mtc0 $k0 $14
eret

archi_error:
addi $17 $0 4
mfc0 $k0 $14
li $2 8
mtc0 $k0 $14
eret

unknow_error:
addi $17 $0 5
mfc0 $k0 $14
addi $k0 $k0 4
mtc0 $k0 $14
eret