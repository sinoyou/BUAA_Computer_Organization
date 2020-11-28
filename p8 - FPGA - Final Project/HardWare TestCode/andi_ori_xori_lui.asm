.macro lii (%tar, %hi, %lo)
	lui %tar, %hi
	ori %tar, %tar, %lo
.end_macro

#andi
andi $1 $0 0xffff
lii $2 0xffff 0xffff
and $3 $2 0x8888
#ori
ori $1 $0 0xffff
lii $2 0xffff 0x7777
ori $3 $2 0x3333
#xori
xori $1 $0 0xffff
lii $2 0xffff 0x7777
xori $3 $2 0x3333

label_loop:
j label_loop
nop