.macro clear
	lui $1 0
	addi $2 $1 0
	andi $3 $1 0
	xor $4 $3 $0
	or $ra $3 $4
	nop
	nop
	nop
	nop
.end_macro
.macro store (%a %b %c)
	ori $6 $0 %a
	addi $5 $0 %c
	sw $6 %b($5)
	nop
	nop
	nop
	nop
.end_macro
.macro initial(%a %b)
	addi $1 $0 %a
	addi $2 $0 %b
	nop
	nop
	nop
	nop
.end_macro

# EM-D: calr-branch-rs
case1: nop
clear
initial 5 100
sub $3 $2 $1
nop
bgtz $3 label1
addi $4 $4 1
addi $4 $4 2
label1:
addi $4 $4 4

# EM-D: cali-branch-rt
case2: nop
clear
initial 1987 8
xor $3 $1 172
nop
bne $0 $3 label2
addi $4 $4 1
addi $4 $4 2
label2:
addi $4 $4 4

# EM-D: jal-jr-rs
case3: nop
clear
initial 0 0 
jal label3
addi $4 $4 1
j case3_end
nop
label3:
jr $ra
addi $4 $4 2
case3_end:

# EM-D: jalr-jalr-rs
case4: nop
clear
initial 0x3158 0			# need to be fixed
jalr $5 $1
addi $4 $4 1
j case4_end
nop
label4: jalr $ra $5
addi $4 $4 2
case4_end:

# EM-E: calr-calr-rs
case5: nop
clear
initial (-10,-16)
sra $3 $1 5
srav $4 $3 $2

# EM-E: cali-calr-rt
case6: nop
clear
initial 100 200
sltiu $3 $1 300
subu $4 $0 $3

# EM-E: jal-cali-rs
case7: nop
clear
initial 0 0
jal label7
addi $4 $ra 1
addi $4 $4 2
label7:

# EM-E: jalr-ld-rs
case8: nop
clear
store (0xabcd, -4000, 0x32a4)		# need to be fixed
initial 0x32a4 0			# need to be fixed
jalr $3 $1
lw $4 -3996($3)
addi $4 $4 2
label8:
nop

# EM-E: calr-st-rs
case9: nop
clear
initial 68 2
sllv $3 $1 $2
sh $2 0($3)

# MW-D: calr-branch-rs
case10: nop
clear
initial 5 100
subu $3 $1 $2
nop
nop
bltz $3 label10
addi $4 $4 1
addi $4 $4 2
label10:
addi $4 $4 4

# MW-D: cali-branch-rt
case11: nop
clear
initial 0x0fff 8
and $3 $1 172
nop
nop
bgtz $3 label11
addi $4 $4 1
addi $4 $4 2
label11:
addi $4 $4 4

# MW-D: jal-jr-rs
case12: nop
clear
initial 0 0 
jal label12
addi $4 $4 1
j case12_end
nop
label12:
addi $4 $4 2
jr $ra
addi $4 $4 4
case12_end:

# MW-D: jalr-jalr-rs
case13: nop
clear
initial 0x3454 0			# need to be fixed
jalr $5 $1
addi $4 $4 1
j case13_end
nop
label13: addi $4 $4 2
jr $5
addi $4 $4 4
case13_end:

# MW-E: calr-calr-rs
case14: nop
clear
initial (-10,-16)
slt $3 $2 $1
nop
addu $4 $3 $2

# MW-E: cali-calr-rt
case15: nop
clear
initial 100 200
xori $3 $1 50
nop
subu $4 $0 $3

# MW-E: jal-cali-rs
case16: nop
clear
initial 0 0
jal label16
addi $4 $4 1
label16:
addi $4 $ra 1
addi $4 $4 2

# MW-E: jalr-ld-rs
case17: nop
clear
store (0xabcd, -4000, 0x35b0)		# need to be fixed
initial 0x35b0 0			# need to be fixed
jalr $3 $1
nop
addiu $4 $4 2
label17: lhu $4 -3996($3)
nop

# MW-E: calr-st-rs
case18: nop
clear
initial 68 2
sllv $3 $1 $2
nop
sb $2 0($3)

# MW-E: cali-st-rt
case19: nop
clear
initial 100 100
lui $3 0xffff
sw $3 0($1)

# MW-D: ld-branch-rs
case20: nop
clear
store 0xffff -16 100
initial 100 0
lh $3 -16($1)
nop
nop
bltz $3 label20
addi $4 $4 1
addi $4 $4 2
label20:
addi $4 $4 4

# MW-D: ld-branch-rt
case21: nop
clear
store 0xffff -16 100
initial 100 0
lhu $3 -16($1)
nop
nop
bne $0 $3 label21
addi $4 $4 1
addi $4 $4 2
label21:
addi $4 $4 4

# MW-D: ld-jr-rs
case22: nop
clear
store 0x37b0 4 200				# need to be fixed
initial 200 0 
lw $3 4($1)
nop
nop
jr $3
addi $4 $4 1
addi $4 $4 2
label22:	addi $4 $4 4

# MW-D: ld-jalr-rs
case23: nop
clear
store 0x3828 4 200				# need to be fixed
initial 200 0 
lw $3 4($1)
nop
nop
jalr $4 $3
addi $4 $4 1
addi $4 $4 2
label23:	addi $4 $4 4

# MW-E: ld-calr-rs
case24: nop
clear
store 250 0 1024
initial 1024 1
lb $3 0($1)
nop
nor $4 $3 $2

# MW-E: ld-calr-rt
case25: nop
clear
store 250 0 2048
initial 1024 1
lbu $3 0($1)
nop
nor $4 $2 $3

# MW-E: ld-cali-rs
case26: nop
clear
store 63 4 508
initial 101 516
lh $3 -4($2)
nop
addi $4 $3 10

# MW-E: ld-st-rs
case27: nop
clear
store 63 4 508
initial 101 516
lh $3 -4($2)
nop
sb $2 0($3)

# MW-M: ld-st-rt
case28: nop
clear
store 600 -1 801
initial 802 799
lw $3 1($2)
sh $3 -6($1)  

# spcial1: mfhi & mtlo - calr cali
clear
initial 100 200
mthi $1
mtlo $2
mfhi $3
xori $3 $3 63
mflo $4
nop
subu $4 $0 $4

# special2: mfhi & mflo - branch
clear
initial 100 100
mthi $1
mtlo $2
mfhi $3
mflo $4
nop
beq $3 $4 label_special2
addi $4 $4 1
addi $4 $4 2
label_special2:	addi $4 $4 4