# 1 
# prepare 
	ori $2 10
	nop
	nop
	nop
	nop
# test
	sub $1 $3 $2
	nop
	bne $1 $2 label1
	nop
	ori $3 1
	label1:
# expect: 3 = 0 

#2
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	ori $2 1
	lui $1 1
	nop
	nop
	nop
	nop
	nop
# test
	srl $2 $2 16
	nop
	bgez $2 label2
	nop
	ori $3 1
	label2:
# expect $3 = 0

#3
# initial
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare

# test
	addi $1 $1 0x30ac						# need to be fixed
	nop
	jalr $ra $1
	nop
	xori $3 $3 1
	label3:
	sltiu $3 $3 2
# expect: $3 = 2

# 4
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	ori $1 0x30e4						# need to be fixed
	nop
	beq $31 $1 label4
	nop
	ori $3 1
	label4:
	ori $3 2
# expect $3 = 2

# 5
# initial 

# preprare

# test
#	jal label5
#	nop
#	label5:
#	jr $ra
#	ori $3, 1
# expect: infinite loop.

# 6
# initial
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	lui $3 1
	lui $2 1
	sw $3, 16($0)
	nop
	nop
	nop
	nop
# test
	lb $1 16($0)
	nop
	nop
	bne $1 $2 label6
	nop
	ori $3 $3 1
	label6:
# expect : $3 = 0x00010000

# 7
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	addi $2 $0 0x3188				# need to be fixed
	nop
	nop
	nop
	nop
# test
	subu $1 $2 $3
	nop
	nop
	jr $1
	nop
	ori $3 2
	label7:
	xori $3 1
# expect $3 = 1

# 8
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	lui $2 100
	nop
	nop
	nop
	nop
# test
	addiu $1 $0 100
	nop
	nop
	beq $2 $1 label8
	nop
	ori $3 2
	label8:
	slti $3 $3 10101
# expect $3=1

# 9
# initial 
# test
#	jal label9
#	nop
#	nop
#	jr $ra
# expect: infinite loop

# 10
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	ori $3 100
	nop
	nop
	nop
# test
	sub $1 $2 $3
	add $2 $1 $2
# expect: $2 = -100

# 11
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	
# test
	lui $1 100
	sllv $2 $1 $1
# expect $2 = 200

# 12
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	ori $1 1
	nop
	nop
	nop
	nop
# test
	srl $1 $1 5
	ori $1 $1 1
# expect $1 = 0x21

# 13
# initial 
#	lui $1 0
#	lui $2 0
#	lui $3 0
#	nop
#	nop
#	nop
#	nop
#	nop
# prepare
#	ori $1 10
#	sw $1, label13				# ???
#	nop
#	nop
#	nop
#	nop
# test
#	jal label 13
#	lw $1, 0($31)
#	label13:
# expect : write 10 to 0x3???

# 14
# initial 
#	lui $1 0
#	lui $2 0
#	lui $3 0
#	nop
#	nop
#	nop
#	nop
#	nop
# prepare
#	ori $1 10
#	nop
#	nop
#	nop
#	nop
# test
#	jal label 13
#	sw $1, -4($31)
# expect : not achieveable due to write data to code memory

# 15
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	ori $3 10
	sw $3, 200($zero)
	nop
	nop
	nop
	nop
# test
	ori $1 100
	lhu $2 100($1)
# expect $2 = 10

# 16
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop	
# prepare
	ori $3 40
	sw $3 24($0)
	nop
	nop
	nop
	nop
# test
	lhu $1 24($0)
	nop
	sb $2 0($1)
# expect write to memory no.40

# 17 - skip
# 18 : skip
# 19
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	ori $3 200
	sw $3 200($0)
	nop
	nop
	nop
	nop
# test
	lw $1, 200($0)
	nop
	lb $2, 0($1)
# expect: $2 = 200

# 20
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	ori $2 3
	nop
	nop
	nop
	nop
# test
	nor $1 $2 $2
	nop
	subu $1 $0 $1
# expect $1 = 7

# 21 - skip : unable to get data from code memory
# 22 - 
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	ori $1 300
	sh $1 0($1)
	nop
	nop
	nop
	nop
# test
	sub $2 $1 $1
	nop
	lw $3 300($2)
# expect : $3 = 300

# 23
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	ori $1 9
	sw $1 44($0)
	nop
	nop
	nop
	nop
# test
	lw $1 44($0)
	sw $1 4($0)
# expect: write 9 to memory no.4

# 24
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
# test
	ori $1 11
	sb $1 80($0)
# expect: write 11 to memory no.80

# 25 
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
# test
	jal label25
	sh $31, 84($0)
	label25:
	nop
# expect: wirte an code address to memory 84

# 26-skip
# 27
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# prepare
	xori $3, $3, 100
	sw $3, 88($0)
	nop
	nop
	nop
	nop
# test
	ori $1 11
	lh $0, 88($0)
	nop
	xor $1 $0 $1
# expect  $ 1 = 11

# 28
# initial 
	lui $1 0
	lui $2 0
	lui $3 0
	nop
	nop
	nop
	nop
	nop
# test
	lui $0 100
	sw $0 92($0)
# expect: write 0 to memory 92
	
