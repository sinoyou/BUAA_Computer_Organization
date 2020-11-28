# branch instruction
addi $1 $0 1			# 1
addi $2 $0 -1			# -1
addi $3 $0 2			# 2
addi $4 $0 -2			# -2
sub $5 $0 $2			# 1
sub $6 $0 $1			# -1
sub $7 $0 $4			# 2
sub $8 $0 $3			# -2

# beq 
block1:
	# no jump
	beq $1 $2 beq_1
	addi $9 $9 1
	addi $9 $9 1
	beq_1:	
	# pos jump
	beq $1 $5 beq_2
	addi $10 $10 1
	addi $10 $10 1
	beq_2: addi $10 $10 100
	# neg jump
	j beq_3_branch1
	nop
	beq_3: addi $11 $11 -19
	j beq_3_branch2
	nop
	beq_3_branch1:
	beq $2 $6 beq_3
	beq_3_branch2:
	addi $11 $11 -10
	addi $11 $11 -10
# bne
block2:
	# no jump
	bne $6 $2 bne_1
	addi $9 $9 1
	addi $9 $9 1
	bne_1:	
	# pos jump 1 - pos - pos
	bne $1 $3 bne_2
	addi $10 $10 1
	addi $10 $10 1
	bne_2: addi $10 $10 100
	# pos jump 2 - pos-  neg
	bne $4 $3 bne_3
	addi $10 $10 2
	addi $10 $10 2
	bne_3: addi $10 $10 50
	# neg jump - neg - neg
	j bne_4_branch1
	nop
	bne_4: addi $11 $11 -19
	j bne_4_branch2
	nop
	bne_4_branch1:
	bne $6 $8 bne_4
	bne_4_branch2:
	addi $11 $11 -10
	addi $11 $11 -10

# blez
block3:
	# no jump - pos
	blez $1 blez_1
	addi $9 $9 1
	addi $9 $9 1
	blez_1:
	# pos jump - zero
	blez $0 blez_2
	addi $10 $10 1
	addi $10 $10 1
	blez_2: addi $10 $10 100
	# neg jump - neg
	j blez_3_branch1
	nop
	blez_3: addi $11 $11 -19
	j blez_3_branch2
	nop
	blez_3_branch1:
	blez $2 blez_3
	blez_3_branch2:
	addi $11 $11 -10
	addi $11 $11 -10
	
# bgtz
block4:
	# no jump - neg
	bgtz $2 bgtz_1
	addi $9 $9 1
	addi $9 $9 1
	bgtz_1:
	# no jump - zero
	bgtz $0 bgtz_2
	addi $10 $10 1
	addi $10 $10 1
	bgtz_2: addi $10 $10 100
	# neg jump - pos
	j bgtz_3_branch1
	nop
	bgtz_3: addi $11 $11 -19
	j bgtz_3_branch2
	nop
	bgtz_3_branch1:
	bgtz $1 bgtz_3
	bgtz_3_branch2:
	addi $11 $11 -10
	addi $11 $11 -10
	
# bltz
block5:
	# no jump - pos
	bltz $5 bltz_1
	addi $9 $9 1
	addi $9 $9 1
	bltz_1:
	# no jump - zero
	bltz $0 bltz_2
	addi $10 $10 1
	addi $10 $10 1
	bltz_2: addi $10 $10 100
	# neg jump - neg
	j bltz_3_branch1
	nop
	bltz_3: addi $11 $11 -19
	j bltz_3_branch2
	nop
	bltz_3_branch1:
	bltz $6 bltz_3
	bltz_3_branch2:
	addi $11 $11 -10
	addi $11 $11 -10
	
# bgez
block6:
	# no jump - neg
	bgez $2 bgez_1
	addi $9 $9 1
	addi $9 $9 1
	bgez_1:
	# pos jump - zero
	bgez $0 bgez_2
	addi $10 $10 1
	addi $10 $10 1
	bgez_2: addi $10 $10 100
	# neg jump - pos
	j bgez_3_branch1
	nop
	bgez_3: addi $11 $11 -19
	j bgez_3_branch2
	nop
	bgez_3_branch1:
	bgez $7 bgez_3
	bgez_3_branch2:
	addi $11 $11 -10
	addi $11 $11 -10