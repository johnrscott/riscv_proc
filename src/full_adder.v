module full_adder(a, b, carry_in,
		  carry_out, alu_out);
   input a, b, carry_in;
   output alu_out, carry_out;
   
   assign alu_out = a ^ b ^ carry_in;
   assign carry_out = (a & b) | (a & carry_in) | (b & carry_in);

`ifdef FORMAL
   always @(*) begin
      assume(carry_in == 0);
      something: assert(carry_out == (a & b & 1));
   end
`endif
   
endmodule
