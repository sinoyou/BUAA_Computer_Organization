.macro lii (%tar, %hi, %lo)
	lui %tar, %hi
	ori %tar, %tar, %lo
.end_macro

# and
lii $1 0xffff 0x0101
and $2 $1 $1
lii $3 0x7777 0x3333
lii $4 0x8888 0xcccc
and $5 $3 $4
and $0 $3 $4
and $0 $4 $3
ori $6 $0 7
ori $7 $0 5
and $8 $6 $7

# or
lii $1 0x7777 0x3333
lii $2 0x8888 0xcccc
or $3 $1 $2
or $0 $4 $3
ori $4 $0 3
ori $5 $0 5
or $6 $4 $5
lii $7 0xabc7 0x7777
or $8 $0 $7

# xor
lii $1 0x7777 0x3333
lii $2 0x8888 0xcccc
xor $3 $1 $2
lii $4 0xffff 0x0101 
lii $5 0xffff 0x0101
xor $6 $4 $5
lii $7 0xfabc 0x782f
lii $8 0xd728 0xcbaa
xor $9 $7 $8

# or
lii $1 0x7777 0x3333
lii $2 0x8888 0xcccc
nor $3 $1 $2
nor $0 $4 $3
ori $4 $0 3
ori $5 $0 5
nor $6 $4 $5
lii $7 0xabc7 0x7777
nor $8 $0 $7

label_loop:
j label_loop
nop