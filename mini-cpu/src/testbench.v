module testbench();

   tb_full_adder full_adder();
   tb_ripple_carry_adder ripple_carry_adder();
   tb_alu alu();
   tb_program_counter program_counter();
   tb_immediate_gen immediate_gen();
   
   initial begin
      $dumpfile("testbench/testbench.vcd");
      $dumpvars(0, testbench);

      #1000 $finish;      
   end
   
endmodule
