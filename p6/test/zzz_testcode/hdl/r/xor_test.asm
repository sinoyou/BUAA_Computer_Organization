.macro test(%d, %s, %t)
    xor %d %s %t
.end_macro

ori $t0 5

lui $t1 0xffff
ori $t1 0xffff # -1

ori $t2 3

lui $t3 0xffff
ori $t3 0xfffe # -2

test($v0,$t0,$t1) # 5 -1
test($v1,$t2,$t0) # 3 5
test($a0,$t3,$t2) # -2 3
test($a1,$t1,$t3) # -1 -2
test($v0,$t1,$t0) # -1 5
test($v1,$t0,$t2) # 5 3
test($a0,$t2,$t3) # 3 -2
test($a1,$t3,$t1) # -2 -1