module testbench();

   tb_uart_tx uart_tx();
   
   initial begin
      $dumpfile("testbench/testbench.vcd");
      $dumpvars(0, testbench);

      #10000 $finish;      
   end
   
endmodule
