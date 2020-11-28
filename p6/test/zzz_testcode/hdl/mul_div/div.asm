ori $1 $0 8 # 3000
ori $2 $0 3 # 3004
div $1 $2 #3008 8/3=2...2
mfhi $1 #300c
mflo $2 #3010
div $2 $1 #3014 2/2=1...0
mfhi $1 #3018
mflo $2 #301c
mthi $2 #3020
mtlo $1 #3024
div $1 $2 #3028
mfhi $1 #302c
mflo $2 #3039

lui $1 0xffff
ori $1 $0 0xfeee # 3000
lui $2 0xffff
ori $2 $0 0xfee2 # 3004
div $1 $2 #3008 8/3=2...2
mfhi $1 #300c
mflo $2 #3010
div $2 $1 #3014 2/2=1...0
mfhi $1 #3018
mflo $2 #301c

lui $1 0x0
ori $1 $0 0xfeee # 3000
lui $2 0xffff
ori $2 $0 0xfee2 # 3004
div $1 $2 #3008 8/3=2...2
mfhi $1 #300c
mflo $2 #3010
div $2 $1 #3014 2/2=1...0
mfhi $1 #3018
mflo $2 #301c

lui $1 0xffff
ori $1 $0 0xfeee # 3000
lui $2 0x0
ori $2 $0 0xfee2 # 3004
div $1 $2 #3008 8/3=2...2
mfhi $1 #300c
mflo $2 #3010
div $2 $1 #3014 2/2=1...0
mfhi $1 #3018
mflo $2 #301c
