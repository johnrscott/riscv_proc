module full_adder(a, b, carry_in,
		  carry_out, alu_out);
   input a, b, carry_in;
   output alu_out, carry_out;
   
   assign alu_out = a ^ b ^ carry_in;
   assign carry_out = (a & b) | (a & carry_in) | (b & carry_in);

`ifdef FORMAL
   always @(*) begin
      assume(carry_in == 0);      
      carry_out_when_a_and_b: assert(carry_out == (a & b));
      alu_out_when_a_or_b: assert(alu_out == (a ^ b));
   end

   always @(*) begin
      assume(a == 0);
      carry_out_when_b_and_carry_in: assert(carry_out == (b & carry_in));
      alu_out_when_b_or_carry_in: assert(alu_out == (b ^ carry_in));
   end

   always @(*) begin
      assume(a == 0);
      assume(b == 0);
      carry_out_zero: assert(carry_out == 0);
      alu_out_is_carry_in: assert(alu_out == carry_in);
   end
`endif
   
endmodule
