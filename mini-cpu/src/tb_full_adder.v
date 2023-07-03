`timescale 1 ns/10 ps

module tb_full_adder;

   reg a, b, carry_in;
   wire sum, carry_out;
   
   localparam period = 20;

   full_adder uut
     (.sum(sum), .carry_out(carry_out),
      .a(a), .b(b), .carry_in(carry_in));

   initial begin

      // output = 0
      a = 0; b = 0; carry_in = 0;
      #period;

      // output = 1
      a = 0; b = 0; carry_in = 1;
      #period;
      a = 0; b = 1; carry_in = 0;
      #period;
      a = 1; b = 0; carry_in = 0;
      #period;

      // output = 2
      a = 0; b = 1; carry_in = 1;
      #period;
      a = 1; b = 0; carry_in = 1;
      #period;
      a = 1; b = 1; carry_in = 0;
      #period;

      // output = 3
      a = 1; b = 1; carry_in = 1;
      #period;

   end;
     
   

endmodule
