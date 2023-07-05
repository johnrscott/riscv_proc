module instruction_memory 
   (output [31:0] instr,
    input [63:0] pc);

   // 32-bit memory, byte addressable, but reads and
   // writes must be 8-byte aligned.
   reg [31:0] im[236];
   wire [6:0] word_address;

   assign word_address = pc[9:3];
   assign read_data = read_en ? im[word_address] : 0;

   // Initialise the instruction memory. Not necessarily
   // synthesizable
   initial begin

      // Instructions here

      // Infinite branch loop (put at end)
      im[0] = 'h00000063;
      

   end
   
endmodule
