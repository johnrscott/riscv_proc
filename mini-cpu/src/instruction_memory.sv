module instruction_memory 
   (output [31:0] instr,
    input [63:0] pc);

   // 32-bit memory, byte addressable, but reads and
   // writes must be 8-byte aligned.
   reg [31:0] im[256];
   wire [6:0] word_address;

   assign word_address = pc[9:3];
   assign instr = im[word_address];

endmodule
