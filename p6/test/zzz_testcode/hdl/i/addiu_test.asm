.eqv instr addiu

.macro test(%t, %s)
    instr %t %s 98
    instr %t %s -865
.end_macro

ori $1 $0 3
ori $2 $0 -87
ori $3 $0 772
ori $4 $0 -1283

test($10, $1)
test($11, $2)
test($12, $3)
test($13, $4)


