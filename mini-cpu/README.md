# Mini RISC-V CPU

This folder contains an implementation of the simple single-cycle RISC-V example shown in Figure 4.17 of "2018 Patterson and Hennessy - Computer organisation and design: the hardware software interface (RISC-V edition)" (abbreviated to PH2018 in this documentation).

The CPU is 64-bit, uses separate program and data memory, and executes the following RISC-V instructions in one clock cycle: 

- **add**: add two registers, place result in a third register
- **sub**: subtract two registers, place result in a third register
- **and**: place bitwise AND of two registers in a third register
- **or**: place bitwise OR of two registers in a third register
- **ld**: load from data memory into a register
- **sd**: store from a register into data memory
- **beq**: compare two registers, and branch to a target address if equal

See the [specification](1_specification.md) for a detailed prescription of what the implementation does. 
