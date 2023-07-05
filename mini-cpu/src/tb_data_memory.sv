`timescale 1 ns/10 ps

module tb_data_memory();
   
   localparam half_cycle = 10;
   localparam period = 20;
   localparam xlen = 64;

   reg 		  clk, rstn;

   reg [xlen-1:0] address, write_data;
   reg 		  write_en, read_en;
   wire [xlen-1:0] read_data;

   integer 	   n;
   
   data_memory uut(.read_data(read_data),
		   .address(address),
		   .write_data(write_data),
		   .write_en(write_en),
		   .read_en(read_en),
		   .clk(clk), .rstn(rstn));
   
   initial begin: clock_loop
      clk = 0;
      rstn = 0;
      write_data = 0;
      address = 0;
      write_en = 0;
      read_en = 0;
      forever begin
	 #half_cycle clk = 1;
	 #half_cycle clk = 0;
      end
   end
   
   initial begin

      // Wait for first clock edge
      #period;

      // Attempt to write in reset
      write_data = 5;
      write_en = 1;
      address = 8;
      #period;
      
      // Check that all the registers is still zero
      read_en = 1;
      for (n=0; n<1024; n++) 
	if (read_data !== 0)
	  $error("Expected memory initially zero");

      // Deassert reset
      rstn = 1;
      read_en = 1;
      #period;

      // Write value again and check it is written
      if (read_data !== 5)
	$error("Expected read_data = 5");

      // Perform writes to the whole memory
      for (n=0; n<128; n++) begin
	 address = 8*n;
	 write_data = 3*n + 1;
	 write_en = 1;
	 #period;	 
      end

      // Read the memory to check
      for (n=0; n<128; n++) begin
	 address = 8*n;
	 read_en = 1;
	 #half_cycle;	 
	 if (read_data !== (3*n+1))
	   $error ("Expected memory address n to be 3n+1");
      end
	
      
   end
   
endmodule
