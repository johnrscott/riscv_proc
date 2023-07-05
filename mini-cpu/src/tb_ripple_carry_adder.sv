`timescale 1 ns/10 ps

module tb_ripple_carry_adder();

   localparam period = 20;
   localparam xlen = 64;

   reg [xlen-1:0] a, b;
   reg 		  carry_in;
   wire [xlen-1:0] sum;
   wire 	   carry_out;
   
   ripple_carry_adder #(.xlen(xlen)) uut
     (.sum(sum),
      .carry_out(carry_out),
      .a(a),
      .b(b),
      .carry_in(carry_in));
   
   integer 	   n;
   
   initial begin
      
      // 0 + 0 = 0
      a = 0;
      b = 0;
      carry_in = 0;
      #period;
      if ((sum !== 0) || (carry_out !== 0))
	$error("Error on output 0 + 0 = 0");

      // 7 + 1 = 8, tests an internal carry
      a = 7;
      b = 1;
      carry_in = 0;
      #period;
      if ((sum !== 8) || (carry_out !== 0))
	$error("Error on output 7 + 1 = 8");
      
      // -1 + 1 = 0, tests carry_out
      a = -1;
      b = 1;
      carry_in = 0;
      #period;
      if ((sum !== 0) || (carry_out !== 1))
	$error("Error on output -1 + 1 = 0");

      // 53 - 48 = 5, tests twos-complement subtraction
      a = 53;
      b = ~48;
      carry_in = 1;
      #period;
      if ((sum !== 5) || (carry_out !== 1))
	$error("Error on output 53 - 48 = 5");
      
   end
      
endmodule
