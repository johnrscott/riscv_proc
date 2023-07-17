module tb_uart_tx();

   uart_tx uut(.serial_out(serial_out),
	       .data_bus(data_bus),
	       .load_xmt_datareg(load_xmt_datareg),
	       .byte_ready(byte_ready),
	       .t_byte(t_byte),
	       .clk(clk),
	       .rst_b(rst_b));
   
   initial begin: clock_loop
      clk = 0;
      rstn = 0;
      imm_branch = 0;
      pc_src = 0;
      forever begin
	 #half_cycle clk = 1;
	 #half_cycle clk = 0;
      end
   end

   initial begin: check_instructions_at_pc_address
      
      pc = 0;
      #period;
      if (instr !== 'h00106433)
	$error("Error in instruction memory at pc = 0");

   end

endmodule
