ori $t0 $0 4

ori $t1 $0 1

lui $t2 0xffff
ori $t2 $t2 0xffff

sw $t1 0($t0)
sw $t2 -4($t0)
sw $t1 8($t0)
sw $t2 12($t0)

lw $v0 0($t0) # 3020
lw $v1 -4($t0)

sw $v0 4($t0) # 3028
sw $v0 12($t0)
