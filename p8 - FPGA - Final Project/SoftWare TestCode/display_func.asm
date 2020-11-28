.eqv timer     0x7f00
.eqv uart       0x7f10
.eqv switch   0x7f2c
.eqv led        0x7f34
.eqv display  0x7f38
.eqv key       0x7f40

li $t0, 0x12345678
sw $t0, display($0)
addi $t1 $0 4
li $t0, 0xffffffff
sw $t0, display($t1)
lw $t2 display($t1)
label:
j label
nop