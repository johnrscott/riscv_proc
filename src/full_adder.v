module full_adder(sum, carry_out, a, b, carry_in);
   
   output sum, carry_out;
   input a, b, carry_in;
   
   assign sum = a ^ b ^ carry_in;
   assign carry_out = (a & b) | (a & carry_in) | (b & carry_in);

`ifdef FORMAL
   always @(*) begin
      assume(carry_in == 0);
      carry_out_when_a_and_b: assert(carry_out == (a & b));
      sum_when_a_or_b: assert(sum == (a ^ b));
   end

   // There is something wrong here -- commenting out the assume line does nothing
   always @(*) begin
      assume(a == 0);
      carry_out_when_b_and_carry_in: assert final(carry_out == (b & carry_in));
      sum_when_b_or_carry_in: assert final(sum == (b ^ carry_in));
   end

   always @(*) begin
      assume(a == 0);
      assume(b == 0);
      carry_out_zero: assert final(carry_out == 0);
      sum_is_carry_in: assert final(sum == carry_in);
   end
`endif
   
endmodule
