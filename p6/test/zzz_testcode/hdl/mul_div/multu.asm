ori $1 $0 1
ori $2 $0 2
multu $1 $2
mfhi $1
mflo $2
multu $2 $1
mfhi $1
mflo $2
mthi $1
mtlo $2
multu $2 $1
mfhi $1
mflo $2

lui $1 0xffff
ori $1 $0 0xfeee
lui $2 0xffff
ori $2 $0 0xfee2
multu $1 $2
mfhi $1
mflo $2
multu $2 $1
mfhi $1
mflo $2
mthi $1
mtlo $2
multu $2 $1
mfhi $1
mflo $2

lui $1 0
ori $1 $0 0xfeee
lui $2 0xffff
ori $2 $0 0xfee2
multu $1 $2
mfhi $1
mflo $2
multu $2 $1
mfhi $1
mflo $2
mthi $1
mtlo $2
multu $2 $1
mfhi $1
mflo $2

lui $1 0xffff
ori $1 $0 0xfeee
lui $2 0
ori $2 $0 0xfee2
multu $1 $2
mfhi $1
mflo $2
multu $2 $1
mfhi $1
mflo $2
mthi $1
mtlo $2
multu $2 $1
mfhi $1
mflo $2