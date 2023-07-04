# Arithmetic and Logic Unit

The ALU is a key component of two parts of the design: the program counter and the core arithmetic and logical computations. This file describes the design of the ALU.

## 64-bit Adder `ripple_carry_adder`

The adder implementation is a simple ripply carry adder, formed using a chain of `full_adder`s.

* **Parameters**
  * `xlen`: the summand and sum length (64-bit)
* **Inputs**
  * `a`: the first `xlen`-bit summand
  * `b`: the second `xlen`-bit summand
  * `carry_in`: the 1-bit carry-in value to be added
* **Outputs (combinational)**
  * `sum`: The `xlen`-bit unsigned sum of `a`, `b` and `carry_in`
  * `carry_out`: the `xlen+1`th bit of the sum
  
## 1-bit ALU

The ALU performs addition and subtraction, logical AND and OR, set if less than, and has a signal indicating zero result.

* **Parameters**
  * `xlen`: the operand and result length (64-bit
* **Outputs (combinational)**
  * `result`: `xlen`-bit: `a`+`b`, `a`-`b`, `a`&`b`, or `a`|`b`, or the set-less-than result, depending on `alu_ctrl` 
  * `zero`: 1-bit, set if `result` = 0
* **Inputs**
  * `a`: the first `xlen`-bit operand
  * `b`: the second `xlen`-bit operand
  * `alu_ctrl`: 3-bit
	* 000: `result` = `a` & `b`
	* 001: `result` = `a` | `b`
	* 010: `result` = `a` + `b`
  	* 110: `result` = `a` - `b`
  	* 111: `result` = 1 if `a` < `b`, zero otherwise

In the `alu_ctrl` lines, bit 0 and 1 distinguish AND, OR, unsigned addition, and set less than (by setting the multiplexer that decides `result`); bit 2 negates operand `b` and sets the `carry_in` of the 64-bit adder, which turns addition into two's-complement subtraction.
