ori $t0 $0 4

ori $t1 $0 1

lui $t2 0xffff
ori $t2 $t2 0xffff

sb $t1 1($t0)
sb $t2 -3($t0)
sb $t1 7($t0)
sb $t2 13($t0)

lb $v0 1($t0) # 3020
lb $v1 -3($t0)
sb $v0 4($t0) # 3028
sb $v0 12($t0)
