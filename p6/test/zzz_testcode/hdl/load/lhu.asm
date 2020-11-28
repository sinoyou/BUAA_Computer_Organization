ori $t0 $0 4

ori $t1 $0 1

lui $t2 0xffff
ori $t2 $t2 0xffff

sh $t1 2($t0)
sh $t2 -2($t0)
sh $t1 6($t0)
sh $t2 12($t0)

lhu $v0 2($t0) # 3020
lhu $v1 -2($t0)

sh $v0 6($t0) # 3028
sh $v0 12($t0)
