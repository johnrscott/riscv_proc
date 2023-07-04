module full_adder
  (output sum, carry_out,
   input a, b, carry_in);
   
   assign sum = a ^ b ^ carry_in;
   assign carry_out = a && b || a && carry_in || b && carry_in;   

endmodule

module ripple_carry_adder
  #(parameter xlen = 3)
   (output [xlen-1:0] sum,
    output 	 carry_out,
    input [xlen-1:0] a, b,
    input 	 carry_in);
   
   wire [xlen:0] carry;
   assign carry_out = carry[xlen];
   assign carry[0] = carry_in;
   genvar 	 n;
   
   generate
      for (n=0; n < xlen; n=n+1) begin
	 full_adder adder_n(.sum(sum[n]),
			    .carry_out(carry[n+1]),
			    .a(a[n]),
			    .b(b[n]),
			    .carry_in(carry[n]));
      end
   endgenerate
   
endmodule
			    
