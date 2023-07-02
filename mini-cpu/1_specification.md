# 1. Specification

This document refers to the "RISC-V Instruction Set Manual, Volume 1 (Unprivileged ISA), Version 20191213" as ISM2019.

## Register Sizes

The CPU contains 32 64-bit registers x0-x31, where x0 is hardwired to zero. The CPU is 64-bit (XLEN=64), so xn are all 64 bits. The program counter, pc, is also 64-bits long. See ISM2019:Fig2.1. 

## Memory Sizes

Instruction memory and data memory are separate, addressed by 64-bit addresses, and are each 1KiB long, starting from address 0. This deviates from the 2^XLEN-1 sized address space in ISM2019:Sec1.4; however, memory still wraps here modulo the 1KiB address space size.

Below, `IM[pc]` will refer to the 32-bit instruction at program counter address `pc` in instruction memory. `DM[rs1 + N]` will refer to the 64-bit word starting at address `rs1 + N`.

## Clocking and Reset Behaviour

The device is synchronised by an external clock. The device is clocked on the rising edge. The device has a synchronous reset input which is active low. Clocking is enabled first with the device held in reset. Execution begins at the first instruction in instruction memory (address 0) on the first rising clock edge after the reset signal is deasserted. 

## Instruction Definitions

The supported instructions come from the RV64-I instruction set (ISM2019:Chap2). 

### Integer Computational Instructions

The integer computational instructions `add`, `sub`, `and`, and `or` operate on two source registers `rs1` and `rs2`, and store the result in a destination register `rd`, all of which may be any of x0-x31. The zero register `x0` may be used. If it is a source, it is equal to zero, and if it is a destination, then the instruction result is discarded. The instructions use the R-type format:

| funct7 | rs2    | rs1    | funct3 | rd     | opcode |
|--------|--------|--------|--------|--------|--------|
| 7 bits | 5 bits | 5 bits | 3 bits | 5 bits | 7 bits |

The `rs1`, `rs2` and `rd` fields contain a number `n` that selects a register `xn`. The following list defines the other values of the opcode fields `opcode`, `funct3` and `funct7`, and states what the instruction does.

* **add rd, rs1, rs2** (rd = rs1 + rs2). Addition is and subtraction are signed, and overflow by wrapping. No special action is taken on overflow.
  * opcode = 51
  * funct3 = 0 (distinguishes from and/or)
  * funct7 = 0 (distinguishes from sub)


* **sub rd, rs1, rs2** (rd = rs1 - rs2). 
  * opcode = 51
  * funct3 = 0 (distinguishes from and/or)
  * funct7 = 32 (distinguishes from add)

* **and rd, rs1, rs2** (rd = rs1 & rs2). 
  * opcode = 51
  * funct3 = 6 (distinguishes from or/add/sub)
  * funct7 = 0

* **or rd, rs1, rs2** (rd = rs1 | rs2). 
  * opcode = 51
  * funct3 = 7 (distinguishes from and/add/sub)
  * funct7 = 0

The `opcode` 51 indicates an arithmetic or logical instruction. The `funct3` field is used distinguish between arithmetic, `and`, or `or`. One bit of `funct7` distinguishes added from subtraction.

### Load and Store Instructions

Load and store instructions move data between registers and data memory. In both instructions, the memory address is obtained by adding an offset to `rs1`. For a load, the destination register is `rd` and for a store, the source register is `rs2`.

The load instruction uses the I-type instruction format:

| immediate[11:0] | rs1    | funct3 | rd     | opcode |
|-----------------|--------|--------|--------|--------|
| 12 bits         | 5 bits | 3 bits | 5 bits | 7 bits |

The `immediate[11:0]` field takes the place of `funct7` and `rs2` in the R-type instruction. The other fields are in the same positions. The immediate value is needed to support addresses at fixed offsets from the value in `rs1`.

The values used in the load instruction is summarised below:

* **ld rd, N(rs1)** (rd = RM[rs1 + N]). 
  * opcode = 3
  * funct3 = 3
  * immediate = N (the immediate field is sign-extended before adding to `rs1`)

The format for store instruction is a modification of the R-type instruction format that preserves the location of `rs1` and `rs2` by splitting the immediate value across two fields:

| immediate[11:5] | rs2    | rs1    | funct3 | immediate[4:0] | opcode |
|-----------------|--------|--------|--------|----------------|--------|
| 7 bits          | 5 bits | 5 bits | 3 bits | 5 bits         | 7 bits |

The values used in store instruction are shown below:

* **sd rs2, N(rs1)** (RM[rs1 + N] = rs2). 
  * opcode = 35 (one bit different from load)
  * funct3 = 3
  * immediate = N (the immediate field is sign-extended before adding to `rs1`)

### Branch Instruction

The branch-if-equal instruction is encoded using a slight modification to S-type, because it also involves two source registers (`rs1` and `rs2`, to be compared for equality), and an immediate offset which is added to the program counter to obtain the new instruction address.

However, the immediate field is always even (RISC-V instructions always at least 2-byte aligned), and the extra bit is used to target a larger branch offset:

| immediate[12,10:5] | rs2    | rs1    | funct3 | immediate[4:1,11] | opcode |
|--------------------|--------|--------|--------|-------------------|--------|
| 7 bits             | 5 bits | 5 bits | 3 bits | 5 bits            | 7 bits |

This format (SB-type) is obtained from S-type by:
* Preserving the location of as many bits of `immediate` as possible
* Preserving the location of the sign bit of `immediate` (now bit 12 instead of bit 11)
* Replacing the least-significant bit of `immediate` (now redundant) with bit 11.

The values in the branch instruction are:

* **beq rs1, rs2, N** (if rs1 == rs2, pc += N). 
  * opcode = 99
  * funct3 = 0
  * immediate = N (N is even; the immediate field is sign-extended before adding to `pc`)





