`timescale 1 ns/10 ps

module tb_full_adder();

   reg a, b, carry_in;
   wire sum, carry_out;
   
   localparam period = 20;

   full_adder uut
     (.sum(sum), .carry_out(carry_out),
      .a(a), .b(b), .carry_in(carry_in));

   initial begin
      
      $dumpfile("testbench/full_adder.vcd");
      $dumpvars(0, tb_full_adder);
      
      // output = 0
      a = 0; b = 0; carry_in = 0;
      #period;
      if ({carry_out, sum} != 2'b00)
	$error("Error on output = 0");

      // output = 1
      a = 0; b = 0; carry_in = 1;
      #period;
      if ({carry_out, sum} != 2'b01)
	$error("Error on output = 1");
      a = 0; b = 1; carry_in = 0;
      #period;
      if ({carry_out, sum} != 2'b01)
	$error("Error on output = 1");
      a = 1; b = 0; carry_in = 0;
      #period;
      if ({carry_out, sum} != 2'b01)
	$error("Error on output = 1");

      // output = 2
      a = 0; b = 1; carry_in = 1;
      #period;
      if ({carry_out, sum} != 2'b10)
	$error("Error on output = 2");
      a = 1; b = 0; carry_in = 1;
      #period;
      if ({carry_out, sum} != 2'b10)
	$error("Error on output = 2");
      a = 1; b = 1; carry_in = 0;
      #period;
      if ({carry_out, sum} != 2'b10)
	$error("Error on output = 2");

      // output = 3
      a = 1; b = 1; carry_in = 1;
      #period;
      if ({carry_out, sum} != 2'b11)
	$error("Error on output = 3");

   end
     
endmodule
