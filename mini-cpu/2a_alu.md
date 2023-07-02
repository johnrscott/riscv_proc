# Arithmetic and Logic Unit

The ALU is a key component of two parts of the design: the program counter and the core arithmetic and logical computations. This file describes the design of the ALU.

## 64-bit Adder `ripple_carry_adder`

The adder implementation is a simple ripply carry adder, formed using a chain of `full_adder`s.
