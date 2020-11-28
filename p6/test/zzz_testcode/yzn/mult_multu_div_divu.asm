.macro lii (%tar, %hi, %lo)
	lui %tar, %hi
	ori %tar, %tar, %lo
.end_macro
.macro exchange
	mfhi $3
	mflo $4
	mthi $4
	mtlo $3
	mfhi $5
	mflo $6
.end_macro

# mult 
#1
lii $1 0x7192 0x3091
lii $2 0 0
mult $1 $2
exchange
#2
lii $1 0x7192 0x3091
lii $2 0x6109 0x8239
mult $1 $2
exchange
#3
lii $1 0xffff 0xff3f
lii $2 0 100
mult $1 $2
exchange
#4
lii $1 0 100
lii $2 0xffff 0xff3f
mult $1 $2
exchange
#5
lii $1 0xffff 0xff3f
lii $2 0xffff 0xff3f
mult $1 $2
exchange

#multu
#1
lii $1 0x7192 0x3091
lii $2 0 0
multu $1 $2
exchange
#2
lii $1 0x7192 0x3091
lii $2 0x6109 0x8239
multu $1 $2
exchange
#3
lii $1 0xffff 0xff3f
lii $2 0 100
multu $1 $2
exchange
#4
lii $1 0 100
lii $2 0xffff 0xff3f
multu $1 $2
exchange
#5
lii $1 0xffff 0xff3f
lii $2 0xffff 0xff3f
multu $1 $2
exchange

# div
#1
lii $1 0 100
lii $2 0 11
div $1 $2
exchange
#2
lii $1 0xffff 0xff9c
lii $2 0xffff 0xfffd
div $1 $2
exchange
#3
lii $1 0xffff 0xff9c
lii $2 0 17
div $1 $2
exchange
#4
lii $1 0 100
lii $2 0xffff 0xffef
div $1 $2
exchange

# divu
#1
lii $1 0 100
lii $2 0 11
divu $1 $2
exchange
#2
lii $1 0xffff 0xff9c
lii $2 0xffff 0xfffd
divu $1 $2
exchange
#3
lii $1 0xffff 0xff9c
lii $2 0 17
divu $1 $2
exchange
#4
lii $1 0 100
lii $2 0xffff 0xffef
divu $1 $2
exchange