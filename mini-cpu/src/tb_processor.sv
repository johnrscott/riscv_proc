`timescale 1 ns/10 ps

module tb_processor();
   
   localparam half_cycle = 10;
   localparam period = 20;
   localparam xlen = 64;

   reg 		  clk, rstn;
   
   wire [xlen-1:0] pc;
   wire 	   main_alu_zero;
   
   processor uut
     (.clk(clk),
      .rstn(rstn),
      .main_alu_zero(main_alu_zero));
   
   initial begin: clock_loop
      clk = 0;
      rstn = 0;
      forever begin
	 #half_cycle clk = 1;
	 #half_cycle clk = 0;
      end
   end
   
   initial begin: load_instruction_memory

      // The instruction memory is an array of 4-byte words
      uut.instruction_memory_0.im[0] = 'h00106433; // x8 = x0 | x1 = -1
      uut.instruction_memory_0.im[1] = 'h0020e4b3; // x9 = x1 | x2 = -1
      uut.instruction_memory_0.im[2] = 'h0020f533; // x10 = x1 & x2 = a
      uut.instruction_memory_0.im[3] = 'h003175b3; // x10 = x2 & x3 = 0
      uut.instruction_memory_0.im[4] = 'h00000633; // x12 = x0 + x0 = 0
      uut.instruction_memory_0.im[5] = 'h001006b3; // x13 = x0 + x1 = -1
      uut.instruction_memory_0.im[6] = 'h00520733; // x14 = x4 + x5 = -13
      uut.instruction_memory_0.im[7] = 'h000007b3; // x15 = x0 - x0 = 0
      uut.instruction_memory_0.im[8] = 'h00520833; // x16 = x4 + x5 = -23
      uut.instruction_memory_0.im[9] = 'h001008b3; // x17 = x0 - x1  = 1

      // Infinite branch loop (put at end)
      uut.instruction_memory_0.im[10] = 'h00000063;
   end
   
   initial begin: check_processor_state
      // Wait for first clock edge
      #period;
      #period;

      // Bring out of reset
      rstn = 1;

      // Since all the registers are set to zero on reset,
      // this must be done after reset (a workaround for the
      // testbench). It must happen before the first rising
      // clock edge, so double check the timing here.
      uut.register_file_0.registers[0] = 0;
      uut.register_file_0.registers[1] = -1;
      uut.register_file_0.registers[2] = 'hf0f0f0f0_f0f0f0f0;
      uut.register_file_0.registers[3] = 'h0f0f0f0f_0f0f0f0f;
      uut.register_file_0.registers[4] = 10;
      uut.register_file_0.registers[5] = -23;
      uut.register_file_0.registers[6] = -13;
      uut.register_file_0.registers[7] = 33;

      
      // 
      
   end      
   
endmodule
