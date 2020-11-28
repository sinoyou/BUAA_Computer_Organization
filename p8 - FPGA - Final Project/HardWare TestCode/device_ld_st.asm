# 此代码测试向设备寄存器写写入位写值和读取设备寄存器值，以验证外设和Bridge正确新
li $t0 15
sw $t0 0x7f00($0)
lw $t0 0x7f00($0)
li $t0 0x5555ffff
sw $t0 0x7f04($0)
lw $t0 0x7f04($0)

# UART
li $t0 0xf8
# sw $t0 0x7f10($0)
# lw $t0 0x7f10($0)
li $t0 0xff
sw $t0 0x7f24($0)
lw $t0 0x7f24($0)
sw $t0 0x7f28($0)
lw $t0 0x7f28($0)

# DISPLAY
li $t0 0x12345678
sw $t0 0x7f38($0)
lw $t0 0x7f38($0)
li $t0 0x00000008
sw $t0 0x7f3c($0)
lw $t0 0x7f3c($0)
