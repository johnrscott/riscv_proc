module instruction_memory 
   (output [31:0] instr,
    input [63:0] pc);
   
   // 32-bit memory, byte addressable, but reads and
   // writes must be 8-byte aligned.
   reg [31:0] im[256];
   wire [7:0] word_address;

   assign word_address = pc[9:2];
   assign instr = im[word_address];

   // Initial value of the instruction memory
   const logic [31:0] initial_instructions[256]
		      = '{0:'h00003083, // x1 = dm[0]
			 1:'h00103103, // x2 = dm[1]
			 // Infinite branch loop (put at end)
			 2:'h00000063,
			  default:'0
			 };
   
   
   initial begin: load_instruction_memory
      im <= initial_instructions;
   end
   
endmodule
