# jal j jr jalr
# 此程序不可随意更改，存在固定写死的跳转地址。

# j
j j_label2
addi $1 $1 -1
addi $1 $1 -2
j_label1:
addi $1 $1 -4
j j_label3
addi $1 $1-8
addi $1 $1 -16
j_label2:
addi $1 $1 -32
j j_label1
addi $1 $1 -64
addi $1 $1 -128
j_label3:

# jal jr jalr
# jal - jr: transmit at D-M
jal function_1_begin
addi $2 $2 1
addi $2 $2 2

# jal - jr: transmit at D-W
jal function_2_begin
addi $3 $3 1
addi $3 $3 2

# jalr - jr: transmit at D-M
ori $10 $0 0x3088 # function_3_begin
jalr $20 $10
addi $4 $4 1
addi $4 $4 2

# jalr - jr: transmit at D-W
ori $11 $0 0x3094 # function_4_begin
jalr $21 $11
addi $5 $5 1
addi $5 $5 2

j program_end
nop

function_1_begin:
	jr $ra
	addi $2 $2 4
	addi $2 $2 8
function_1_end:

function_2_begin:
	add $3 $3 $ra
	jr $ra
	addi $3 $3 4
	addi $3 $3 8
function_2_end:

function_3_begin:
	jr $20
	addi $4 $4 4
	addi $4 $4 8
function_3_end:

function_4_begin:
	add $5 $21 $5
	jr $21
	addi $5 $5 4
	addi $5 $5 8
function_4_end:
function_5_begin:

function_5_end:
function_6_begin:

function_6_end:

program_end: