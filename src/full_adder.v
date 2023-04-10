module full_adder(a, b, carry_in,
		  carry_out, alu_out);
   input a, b, carry_in;
   output alu_out, carry_out;
   
   assign alu_out = a ^ b ^ carry_in;
   assign carry_out = (a & b) | (a & carry_in) | (b & carry_in);
   
endmodule
