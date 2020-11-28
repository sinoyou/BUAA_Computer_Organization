`timescale 1ns / 1ps
`define pcsel_size 3
`define aluop_size 5
`define alusrc_size 2
`define wasel_size 2
`define wdsel_size 2
`define tmux_size 3
`define cmpop_size 3
`define xaluop_size 3
`define alusel_size 2
`define start_size 2
`define xaluop_size 3
`define store_type_size 2
`define load_type_size 2

// from datapath and main ctrl
`define op 31:26
`define func 5:0
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define s 10:6
`define im16 15:0
`define im26 25:0

// from hazard
`define op 31:26
`define func 5:0
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define no_more_use 7
`define no_more_new 0
`define neverwrite 0
`define EM_ALU 1						// 写入数据存在端口1
`define MW_ALU 2						// 写入数据存在端口2
`define MW_MD 3						// 写入数据存在端口3
`define MW_CP0 4						// 写入数据存在端口4

// from dm
`define dm_size 2048
// from im
`define im_size 2048
// from IDU
`define irn_size 8
`define irtype_size 4
// from EXCMUX
`define exc_size 5
// from Display Driver
`define display_scale 100000

// memory address limit
`define dm_begin 32'h0000_0000
`define dm_end   32'h0000_1fff
`define im_begin 32'h0000_3000
`define im_end   32'h0000_4fff
`define timer_begin 32'h0000_7f00
`define timer_end	  32'h0000_7f0b
`define uart_begin  32'h0000_7f10
`define uart_end	  32'h0000_7f2b
`define switch_begin 32'h0000_7f2c
`define switch_end	32'h0000_7f33
`define led_begin		32'h0000_7f34
`define led_end		32'h0000_7f37
`define display_begin 32'h0000_7f38
`define display_end   32'h0000_7f3f
`define key_begin		 32'h0000_7f40
`define key_end		 32'h0000_7f43