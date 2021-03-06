## Repo For the Coursework of BUAA Computer Organization 2018

### Basic Information

- **Author**: Zinuo You
- **Course Grade**: 100/100
- **Evaluation**: Independent Development, Black Box Test + Q&A
- **Coding Language**: Verilog, MIPS32, Python (for auto test)
- **Software**: Xilinx ISE, MARS (MIPS32 assemble simulator), Logisim (interactive circuits simulator)
- **Reference:** The course is developed  on [UC Berkeley CS61C Great Ideas in Computer Architecture](https://cs61c.org)
- **Guide Book**
  - [BUAA CS Core MOOC](http://cscore.net.cn)
  - [See MIPS Run Linux](See-Mips-Run-Linux.pdf)



### Project Introduction

#### P0

- **Target**: Warm up for computational structure. Build basic combinational and sequential circuits with gate circuits. 
- **Software:** Logisim

#### P1

- **Target**: Warm up for implementing circuits with Verilog. 
- **Software and Coding Language:** Xilinx ISE; Verilog

#### P2

- **Target**: Warm up for MIPS. Implement algorithms with assemble code or translate C programs to assemble programs. 
- **Software and Coding Languages:** MARS; MIPS32

#### P3

- **Target**: Design and build a **single-cycle CPU** supporting **7** basic MIPS instructions **in an interactive form**. 
- **Software:** Logisim, MARS; MIPS32
- **Report:** [P3-CPU-Report(Chinese)](p3/P3-CPU-Report.pdf)
<div align=center>
<img src="readme.assets/76D5AD05-8A19-4650-A4B5-7756A057914E_1_105_c.jpeg" alt="76D5AD05-8A19-4650-A4B5-7756A057914E_1_105_c" width="600"/>
</div>

#### P4

- **Target**: 
  - Design and build a **single-cycle CPU** supporting **7** basic MIPS instructions **with hardware description language(HDL)**.
- **Software and Languages:** Xilinx ISE, MARS; Verilog, MIPS32
- **Report:** [P4-CPU-Report(Chinese)](p4/P4-CPU-Report.pdf)

#### P5

- **Target**: 
  - Design and build a **5-level pipeline CPU** supporting **7** basic MIPS instructions with **full forwarding and least holding times**. 
- **Software and Languages:** Xilinx ISE, MARS; Verilog, MIPS32
- **Report:** [P5-CPU-Report(Chinese)](p5/P5-CPU-Report.pdf)
<div align=center><img src="readme.assets/image-20201203201102327.png" alt="image-20201203201102327" width="600"/></div>

#### P6

- **Target**: 
  - Design and build a **5-level pipeline CPU** supporting **50** MIPS instructions with **full forwarding and least holding times**. 
  - Develop the CPU with engineering methods, which enables swift adjustments under new requirements. 
- **Software and Languages:** Xilinx ISE, MARS; Verilog, MIPS32
- **Report:** [P6-CPU-Report(Chinese)](p6/P6-CPU-Report.pdf)

#### P7

- **Target**: 
  - Design and build a **pipeline CPU** with **CP0**, supporting **54** MIPS instructions and **exceptions and interrupts**. 
  - Implement a **micro system hardware** with CPU, system bridge, drivers and timers. 
- **Software and Languages:** Xilinx ISE, MARS; Verilog, MIPS32
- **Report:** [P7-CPU-Report(Chinese)](p7/P7-CPU-Report.pdf)
<div align=center><img src="readme.assets/image-20201203202440253.png" alt="image-20201203202440253" width="500" /></div>

#### P8

- **Target**: 
  - Design and build on **FPGA** a **pipeline CPU** supporting **53** MIPS instructions and **exceptions and interrupts**. 
  - Implement on **FPGA** the hardware part of a **micro system**, including CPU, system bridge, drivers and devices. 
  - Implement the software part of a **micro system** with assemble code to run tasks such as arithmetic, timing and message echo. 
- **Software and Languages:** Xilinx ISE, MARS; Verilog, MIPS32
- **Report:** 
  - [P8-CPU-Report(Chinese)](p8/P8-CPU-Report.pdf)
  - [P8-OS-Report(Chinese)](p8/P8-OS-Report.pdf)
<div align=center><img src="readme.assets/FA73C03D-C81F-4502-AFBA-271A7F580824_1_105_c.jpeg" alt="FA73C03D-C81F-4502-AFBA-271A7F580824_1_105_c" width="600" /></div>



### Appendix

#### Supported MIPS32 Instructions

<div align=center><img src="readme.assets/image-20201128205958916.png" alt="image-20201128205958916" width="400" /></div>

#### Data Path of P8 CPU

<div align=center><img src="readme.assets/图片 1.png" alt="图片 1" width="600" /></div>

#### Rules for Hold and Forward in Pipeline CPU (Tuse/Tnew)

| IF/ID |         |      | ID/EX(Tnew) | EX/MEM    | MEM/WB  |            |            |           |            |           |           |         |           |           |           |            |                  |
| ----- | ------- | ---- | ----------- | --------- | ------- | ---------- | ---------- | --------- | ---------- | --------- | --------- | ------- | --------- | --------- | :-------: | ---------- | ---------------- |
| Type  | Src Reg | Tuse | calr/rd/1   | cali/rt/1 | ld/rt/2 | jal/$31/1  | jalr/rd/1  | mfc0/rt/2 | mtc0/epc/2 | calr/rd/0 | cali/rt/0 | ld/rt/1 | jal/$31/0 | jalr/rd/0 | mfc0/rt/1 | mtc0/epc/1 | Stall_Impossible |
| calr  | rs/rt   | 1    |             |           | STOP    |            |            | STOP      |            |           |           |         |           |           |           |            |                  |
| cali  | rs      | 1    |             |           | STOP    |            |            | STOP      |            |           |           |         |           |           |           |            |                  |
| ld    | rs      | 1    |             |           | STOP    |            |            | STOP      |            |           |           |         |           |           |           |            |                  |
| st    | rs      | 1    |             |           | STOP    |            |            | STOP      |            |           |           |         |           |           |           |            |                  |
| st    | rt      | 2    |             |           |         |            |            |           |            |           |           |         |           |           |           |            |                  |
| btype | rs/rt   | 0    | STOP        | STOP      | STOP    | Impossible | Impossible | STOP      |            |           |           | STOP    |           |           |   STOP    |            |                  |
| jr    | rs      | 0    | STOP        | STOP      | STOP    | Impossible | Impossible | STOP      |            |           |           | STOP    |           |           |   STOP    |            |                  |
| jalr  | rs      | 0    | STOP        | STOP      | STOP    | Impossible | Impossible | STOP      |            |           |           | STOP    |           |           |   STOP    |            |                  |
| mtc0  | rt      | 2    |             |           |         |            |            |           |            |           |           |         |           |           |           |            |                  |
| eret  |         |      |             |           |         |            |            |           | STOP       |           |           |         |           |           |           | STOP       |                  |

#### Supported Exceptions of P8 CPU

<div align=center><img src="readme.assets/图片 1-6568542.png" alt="图片 1" width="700" /></div>
