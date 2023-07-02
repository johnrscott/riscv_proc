# Design

The design is based on the simple single-cycle design described in PH2018:Chap4. Refer to Figure 4.17 while reading the following notes.

There are three storage elements in the design:
* the program counter, `pc`
* the register file, x0-x32
* the data memory

For the purposes of this design, the instruction memory is considered read-only and combinational, even if it is implemented in registers (writing the program counter to its address port will immediately load the instruction, as if it were combinational).

All instructions of the computer operate in a single-cycle, meaning that the calculation is combinational; the operating of the computer involves three stages:
1. The program counter register is updated on a rising clock edge. Immediately (combinationally), the instruction appears at the output of the instruction memory.
2. Immediately, the datapath "executes" the instruction (really, propagates the calculation through combinational logic), and the output stabilises at the input to the storage elements of the design (the register file and data memory).
3. The instruction completes on the next rising clock edge, where the output data are clocked into the register file and data memory. This rising edge is also the start of the next instruction.

The combinational logic of the datapath must stabilise at least a *setup time* before the next rising clock edge (so that the results stored into the registers and data memory are valid). The datapath must hold the data in place for at least a *hold time* after the rising clock edge (so that the loading of the next instruction's program counter does not disturb the storing of data from the last instruction, which both happen at the same clock edge).

The following sections describe the requirements of the modules that make up the datapath.

## Program counter `program_counter`

The program counter is the main state register that defines what will happen in the next instruction cycle. It has the following behaviour:

* **State**
  * `pc`: 64-bit register
* **Inputs**
  * `immediate`: value to add to `pc` if `pc_src` = 1
  * `clk`: rising-edge clock
  * `rstn`: synchronous active-low reset. 
  * `pc_src`: 1 bit
	* 0: add 4 to `pc` on clock edge
	* 1: add `immediate` to `pc` on clock edge
* **Outputs (combinational)**
  * `pc`: 64-bit read-only net of `pc`

The program counter is used to address the `instruction_memory`.

## Instruction memory `instruction_memory`

The instruction memory is a read-only view of the instructions. It is addressed with 64 bits, but is only 1KiB in size. It is combinational, in the sense that changes on the address input immediately translate to changes on the output port. It has the following behaviour:

* **State** 
  * `im`: the instruction memory, 256 4-byte words, pre-loaded with an instruction at synthesis-time.
* **Inputs**
  * `pc`: the program counter (output of `program_counter`). Must be 4-byte aligned.
* **Outputs (combinational)**
  * `instr`: `im[pc]`, the 32-bit instruction word at address `pc` (immediately updated on `pc` change).
  
## Register file `register_file`

The register file requires two combinational paths to read `rs1` and `rs2`, and a sequential input to update `rd`. The behaviour is as follows:

* **State**
  * `registers`: an array of 32 64-bit registers, initialised to zero
* **Inputs**
  * `rs1`: a 5-bit integer identifying the register `rs1` to read
  * `rs2`: a 5-bit integer identifying the register `rs2` to read
  * `rd`: a 5-bit integer identifying the register `rd` to write (if `rd` is zero, no write is performed)
  * `rd_data`: the data to write to `rd`, if `write_en` is set
  * `clk`: clock; on rising edge, `rd_data` written to `rd` if `write_en` is set
  * `rstn`: synchronous active-low reset; sets all `registers` to zero 
  * `write_en`: determines whether to write `rd_data` to `rd`
* **Outputs (combinational)**
  * `rs1_data`: 64-bit read-only net of the register referred to by `rs1`
  * `rs2_data`: 64-bit read-only net of the register referred to by `rs2`

The register file propagates the values of the read-registers immediately when `rs1` and `rs2` are set; these values propagate through the rest of the datapath, eventually providing the input `rd_data`, which is loaded into `rd` on the next rising clock edge.

## Data memory `data_memory`

The data memory is 1KiB (byte-addressable), and requires one port which is used for both writing and reading. The read path is combinational (the output is immediately available on setting the address), but data is only written on a rising clock edge. 

Since the read output is combinational, a read enable flag is used to prevent junk on the output port when a write is being performed.

The behaviour is as follows:

* **State**
  * `dm`: an array of 1024 bytes, initialised to zero
* **Inputs**
  * `address`: a 64-bit integer identifying the 
  * `write_data`: 64-bit data to write, if `write_en` is set
  * `clk`: clock; on rising edge, `write_data` written to `dm` if `write_en` is set
  * `rstn`: synchronous active-low reset; sets all bytes in`dm` to zero 
  * `write_en`: determines whether to write `write_data` to `dm`
  * `read_en`: 1 bit.
	* 0: set `read_data` to zero
	* 1: set `read_data` to the 64-bit word starting at `address`
* **Outputs (combinational)**
  * `read_data`: 64-bit word starting at `address`; updated immediately when `address` and `read_en` are changed

## Arithmetic and Logic Unit `main_alu`

The ALU is a combinational unit instantiated several times for different purposes: for the core arithmetic and logic instructions; for the address calculation for loads and stores; and for updating the program counter. It needs to be able to do the following:
* Add and subtract signed 64-bit values
* Bitwise AND and OR 64-bit values
* Provide a signal indicating equality for branch-if-equal

* **Inputs**
  * `a`: first 64-bit input to the ALU
  * `b`: second 64-bit input to the ALU
  * `alu_ctrl`: 3-bit
	* 000: `result` = `a` AND `b`
	* 001: `result` = `a` OR `b`
	* 010: `result` = `a` + `b` (signed)
	* 110: `result` = `a` - `b` (signed)
* **Outputs (combinational)**
  * `result`: the 64-bit result from the ALU (operation depends on `alu_ctrl`)
  * `zero`: 1 bit, set if `result` is zero

## Immediate value generation `immediate_gen`

The immediate field in the instruction is used for two purposes in this computer: 
1. memory address offsets in loads and stores
2. branch offsets in the branch-if-equal instruction. 

In both cases, the immediate is generated from fields `instr[11:7]` (`imm_low`) and `instr[31:25]` (`imm_high`). However, the instruction format is arranged in such a way that both the sign-extension and the shift-left-by-1 required for `beq` are easily accomplished: 

1. first (for both `ld/sd` and `beq`), concatenate `{imm_high, imm_low}`, and sign extend to 64-bit based on the most-significant bit to make `imm_mem`.
2. perform the left shift (`beq` only) by moving the least significant bit `imm_mem[0]` to `imm_mem[11]` to form `imm_branch`. The sign bit that was previously in this position was already duplicated upwards by the sign extension in step 1.

The behaviour of the module is as follows:

* **Inputs**
  * `instr`: the 32-bit `instr` output from the `instruction_memory` 
* **Outputs (combinational)**
  * `imm_mem`: the 64-bit signed offset for memory address computation. Formed from the sign-extended 12-bit immediate in the `instr` word.
  * `imm_branch`: the 64-bit signed offset for branch offsets. Formed by sign-extending the 13-bit immediate offset encoded in the `instr` word.

## Control unit `control`

The control unit reads the `instr` output from the instruction memory, and combinationally sets all the control lines required for the datapath modules above:

* **Inputs**
  * `instr`: the 32-bit `instr` output from the `instruction_memory` 
* **Outputs (combinational)**
  * `branch`: 1 if `instr` is a branch instruction, 0 otherwise. This is combined with the `zero` output of the ALU to generate `pc_src` (indicating branch-taken) 
  * `mem_to_reg`: multiplexer control:
	* 0: `rd_data` of `register_file` is from `result` of `main_alu`
	* 1: `rd_data` of `register_file` is from `read_data` of `data_memory`
  * `reg_write`: drives `write_enable` of `register_file`; 1 to write to register file, zero for no write
  * `mem_read`: drives `read_en` of `data_memory`; 1 to enable a data memory read, 0 otherwise.
  * `mem_write`: drives `write_en` of `data_memory`; 1 to write to data memory, 0 otherwise.
  * `alu_src`: multiplexer control:
	0: input `b` of `main_alu` is `rs2` output of `register_file`
	1: input `b` of `main_alu` is `imm_mem` output of `immediate_gen`
  * `alu_ctrl`: 3-bit, drives the `alu_ctrl` input to `main_alu` 

| Instruction            | `branch` | `mem_to_reg` | `reg_write` | `mem_read` | `mem_write` | `alu_src` | `alu_ctrl` |
|------------------------|----------|--------------|-------------|------------|-------------|-----------|------------|
| `add`/`sub`/`and`/`or` | 0        | 0            | 1           | x          | 0           | 0         | see below  |
| `ld`                   | 0        | 1            | 1           | 1          | 0           | 1         | 010        |
| `sd`                   | 0        | x            | 0           | x          | 1           | 1         | 010        |
| `beq`                  | 1        | x            | 0           | x          | 0           | 0         | 110        |

Notes:
* When `reg_write` is deasserted, nothing in the register-writeback datapath matters: `mem_to_reg` and `mem_read`.
* When `mem_to_reg` is 0, the memory read output does not matter because it is not connected to anything.
* `branch` cannot be x, because otherwise the `zero` ALU output could accidentally cause a branch on arithmetic
* `write_data` cannot x, because the memory write data input is permanently connected to the register file output

For arithmetic and logic instructions, the `alu_ctrl` field is defined as follows:

| Instruction | `alu_ctrl` |
|-------------|------------|
| `add`       | 010        |
| `sub`       | 110        |
| `and`       | 000        |
| `or`        | 001        |
