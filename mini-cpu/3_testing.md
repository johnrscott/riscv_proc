# Testing

## Processor Simulation

The CPU contains only `add`, `sub`, `and`, `or`, `ld`, `sd` and `beq`. None of these instructions can be used to create non-zero memory or register values if they all start out initially as zero. As a result, the simulation testbenches will preset the memory and registers for the tests.

### Arithmetic and Logic Tests

These tests check that the arithmetic and logic functions work across all the registers. No memory or branch operations are performed. The memory is preloaded with the following values:

- `x0`: 00000000 00000000 (0)
- `x1`: ffffffff ffffffff (-1)
- `x2`: f0f0f0f0 f0f0f0f0 (a)
- `x3`: 0f0f0f0f 0f0f0f0f (b)
- `x4`: 00000000 0000000a (10)
- `x5`: ffffffff ffffffe9 (-23)
- `x6`: ffffffff fffffff3 (-13 = 10 + -23)
- `x7`: 00000000 00000023 (33 = 10 - -23)
- `x8`-`x31`: 0

#### Non-overlapping operand/result registers

The following set of instruction performs arithmetic and logic on the first 8 registers, and writes the results to the higher registers. Encoded instructions are shown in the comments, along with what operation is performed.

```asm
or x8, x0, x1 // 00106433, x8 = x0 | x1 = -1
or x9, x1, x2 // 0020e4b3, x9 = x1 | x2 = -1

and x10, x1, x2 // 0020f533, x10 = x1 & x2 = a
and x11, x2, x3 // 003175b3, x10 = x2 & x3 = 0

add x12, x0, x0 // 00000633, x12 = x0 + x0 = 0
add x13, x0, x1 // 001006b3, x13 = x0 + x1 = -1
add x14, x4, x5 // 00520733, x14 = x4 + x5 = 10 + -13 = -13

sub x15, x0, x0 // 000007b3, x15 = x0 - x0 = 0
sub x16, x4, x5 // 00520833, x16 = x4 + x5 = 10 - -13 = -23
sub x17, x0, x1 // 001008b3, x17 = x0 - x1 = 0 - -1 = 1
```

