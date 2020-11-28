li $t0 0x12345679
li $s0 0x00007f00
li $s1 0x00007f10
sw $t0 0($s0)
sw $t0 4($s0)
# sw $t0 8($s0)
sw $t0 0($s1)
sw $t0 4($s1)
# sw $t0 8($s1)
lw $t1 0($s0)
lw $t1 4($s0)
lw $t1 8($s0)
lw $t2 0($s1)
lw $t2 4($s1)
lw $t2 8($s1)