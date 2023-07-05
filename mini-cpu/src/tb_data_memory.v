`timescale 1 ns/10 ps

module tb_data_memory();
   
   localparam half_cycle = 10;
   localparam period = 20;
   localparam xlen = 64;

   reg 		  clk, rstn;

   reg [xlen-1:0] address, write_data;
   reg 		  write_en, read_en;
   wire [xlen-1:0] read_data;

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
      
      
   end
   
endmodule
