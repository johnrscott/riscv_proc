module data_memory 
   (output [63:0] read_data,
    input [63:0] address, write_data,
    input write_en, read_en, clk, rstn);

   // 64-bit memory, byte addressable, but reads and
   // writes must be 8-byte aligned.
   reg [63:0] dm[128];
   wire [6:0] word_address;
   integer    n;
   
   assign word_address = address[9:3];
   assign read_data = read_en ? dm[word_address] : 0;

   always @(posedge clk) begin
      if (!rstn)
	for (n=0; n<128; n++)
	  dm[n] <= 0;
      else if (write_en)
	dm[word_address] <= write_data;
   end

   // Initial value of the data memory. Note array size must
   // be the same as the actual memory
   const logic [63:0] initial_data[128] = '{0:1, 1:2, default:0};

   initial begin: load_data_memory
      dm <= initial_data;
   end
   
endmodule
