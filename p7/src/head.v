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
`define EM_ALU 1						// д�����ݴ��ڶ˿�1
`define MW_ALU 2						// д�����ݴ��ڶ˿�2
`define MW_MD 3						// д�����ݴ��ڶ˿�3
`define MW_CP0 4						// д�����ݴ��ڶ˿�4

// from dm
`define dm_size 4096
`define dm_high_edge 32'h00002fff
// from im
`define im_size 4096
// from IDU
`define irn_size 8
`define irtype_size 4
// from EXCMUX
`define exc_size 5