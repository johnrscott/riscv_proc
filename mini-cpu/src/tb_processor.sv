`timescale 1 ns/10 ps

module tb_processor();
   
   localparam half_cycle = 10;
   localparam period = 20;
   localparam xlen = 64;

   reg 		  clk, rstn;
   
   wire [xlen-1:0] pc;
   
   processor uut
     (.clk(clk),
      .rstn(rstn));
   
   initial begin: clock_loop
      clk = 0;
      rstn = 0;
      forever begin
	 #half_cycle clk = 1;
	 #half_cycle clk = 0;
      end
   end

   initial begin: load_data_memory


   end

   initial begin: load_instruction_memory

      // Instructions here

      // Infinite branch loop (put at end)
      uut.instruction_memory_0.im[0] = 'h00000063;      

   end
   
   initial begin: check_processor_state

      // Wait for first clock edge
      #period;
      
   end      
   
endmodule
