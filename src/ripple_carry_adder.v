module ripple_carry_adder(sum, a, b, carry_out);
   output [3:0]	sum;
   output	carry_out;
   input [3:0] a, b;

   wire [3:0]	carry;
   
   full_adder fa0 (sum[0], carry[0], a[0], b[0], 0);
   full_adder fa1 (sum[1], carry[1], a[1], b[1], carry[0]);
   full_adder fa2 (sum[2], carry[2], a[2], b[2], carry[1]);
   full_adder fa3 (sum[3], carry[3], a[3], b[3], carry[2]);
   
   assign carry_out = carry[3];

`ifdef FORMAL
   always @(*) begin
      output_is_unsigned_addition: assert final(sum == (a + b));
      carry_out_asserted: assert final(carry_out == (5'(a) + 5'(b) > 4'b1111));
   end
`endif  
endmodule
