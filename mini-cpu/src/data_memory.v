module data_memory 
   (output [63:0] read_data,
    input [63:0] address, write_data,
    input write_en, read_en, clk, rstn);

   // Arranged as a list of bytes
   reg [7:0] dm[9:0];

   wire [7:0] byte_addresses[3:0];
   wire [63:0] read_data_internal;
   
   genvar 		n;
   
   // Compute addresses of read data
   generate
      for (n=0; n<8; n=n+1)
	alu #(.xlen(64)) alu_n
	     (.result(byte_addresses[n]),
	      .a(address),
	      .b(n),
	      .alu_ctrl(3'b010));   
   endgenerate

   // Read the data at computed byte addresses
   // generate
   for (n=0; n<8; n++)
     assign read_data_internal[(8*n)+:8] = dm[byte_addresses[n]];
      
   assign read_data = read_en ? read_data_internal : 0;
   
endmodule
