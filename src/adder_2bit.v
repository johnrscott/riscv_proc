module adder_2bit(a, b, alu_out, carry_out);
   input [1:0] a, b;
   output [1:0]	alu_out;
   output	carry_out;

   wire [1:0]	carry_out_internal;
   
   full_adder full_adder_0 (a[0], b[0], 0, carry_out_internal[0], alu_out[0]);
   full_adder full_adder_1 (a[1], b[1], carry_out_internal[0], carry_out_internal[1], alu_out[1]);

   assign carry_out = carry_out_internal[1];

`ifdef FORMAL
   always @(*) begin
      output_is_unsigned_addition: assert(alu_out == a + b);
      carry_out_asserted: assert(carry_out == 0);
   end
`endif  
endmodule
