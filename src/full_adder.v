module full_adder(sum, carry_out, a, b, carry_in);
   
   output sum, carry_out;
   input a, b, carry_in;
   
   assign sum = a ^ b ^ carry_in;
   assign carry_out = (a & b) | (a & carry_in) | (b & carry_in);

`ifdef FORMAL
   always @(*) begin
      if (carry_in == 0) begin
	 carry_out_when_a_and_b: assert(carry_out == (a & b));
	 sum_when_a_or_b: assert(sum == (a ^ b));
      end

      if (a == 0) begin 
	 carry_out_when_b_and_carry_in: assert final(carry_out == (b & carry_in));
	 sum_when_b_or_carry_in: assert final(sum == (b ^ carry_in));
      end
      
      if (a == 0 && b == 0) begin
	 carry_out_zero: assert final(carry_out == 0);
	 sum_is_carry_in: assert final(sum == carry_in);
      end
   end
`endif
   
endmodule
