module testbench();

   tb_full_adder full_adder();
   tb_ripple_carry_adder ripple_carry_adder();

   initial begin
      $dumpfile("testbench/testbench.vcd");
      $dumpvars(0, testbench);
   end
   
endmodule