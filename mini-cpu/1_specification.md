# 1. Specification

This document refers to the "RISC-V Instruction Set Manual, Volume 1 (Unprivileged ISA), Version 20191213" as ISM2019.

## Register Sizes

The CPU contains 32 64-bit registers x0-x31, where x0 is hardwired to zero. The CPU is 64-bit (XLEN=64), so xn are all 64 bits. The program counter, pc, is also 64-bits long. See ISM2019:Fig2.1. 

## Memory Sizes

Instruction memory and data memory are separate, addressed by 64-bit addresses, and are each 1KiB long, starting from address 0. This deviates from the 2^XLEN-1 sized address space in ISM2019:Sec1.4; however, memory still wraps here modulo the 1KiB address space size.

## Clocking and Reset Behaviour

The device is synchronised by an external clock. The device is clocked on the rising edge. The device has a synchronous reset input which is active low. Clocking is enabled first with the device held in reset. Execution begins at the first instruction in instruction memory (address 0) on the first rising clock edge after the reset signal is deasserted. 

## Instruction Definitions

The supported instructions come from the RV64-I instruction set (ISM2019:Chap2). 

### Integer Computational Instructions

The integer computational instructions `add`, `sub`, `and`, and `or` operate on two source registers `rs1` and `rs2`, and store the result in a destination register `rd`, all of which may be any of x0-x31. The zero register `x0` may be used. If it is a source, it is equal to zero, and if it is a destination, then the instruction result is discarded. The instructions use the R-type format:

| funct7 | rs2    | rs1    | funct3 | rd     | opcode |
| 7 bits | 5 bits | 5 bits | 3 bits | 5 bits | 7 bits |

The `rs1`, `rs2` and `rd` fields contain a number `n` that selects a register `xn`. The following list defines the other values of the opcode fields `opcode`, `funct3` and `funct7`, and states what the instruction does.

* **add rd, rs1, rs2** (rd = rs1 + rs2). Addition is and subtraction are signed, and overflow by wrapping. No particular action is taken on overflow.
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

