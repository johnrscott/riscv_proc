module full_adder(output sum, carry_out,
		  input a, b, carry_in);
   assign sum =  a ^ b ^ carry_in;
   assign carry_out = a && b || a && carry_in || b && carry_in;
   
endmodule
