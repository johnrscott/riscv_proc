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

See the following design documents:
1. [Specification](1_specification.md) contains a detailed prescription of what the implementation does. 
2. [Design](2_design.md) describes the elements of the top-level module (following PH2018:Fig4.17)

To synthesize the design, run `. ../settings.sh` and then `start_vivado` to begin a Vivado TCL shell. Then, either step through the commands in `run.tcl`, or run the entire script to synthesize. To open the Vivado GUI to inspect the design at any point, use `start_gui` (and `stop_gui` when you are done). To run the testbenches, run `make`.
