module immediate_gen
  #(parameter xlen = 64) 
   (output [xlen-1:0] imm_mem, imm_branch,
    input [32:0] instr);

   // The 12-bit immediate field taken 
   // S- and SB-type instruction formats
   wire [12:0] 	 imm12;
   wire 	 sign_bit;
   
   assign imm12 = { instr[31:25], instr[11:7] };
   assign sign_bit = imm12[11];

   // Sign-extend up to xlen bits. Note that -1 
   // is the all-one string
   assign imm_mem[11:0] = imm12;   
   assign imm_mem[xlen-1:12] = sign_bit ? -1 : 0;

   // Left-shift to get the 13-bit branch offset.
   // No shift is performed -- the instruction is
   // laid out in such a way that 
   always @(*) begin
      imm_branch = imm_mem;
      imm_branch[11] = imm_branch[0];
      imm_branch[0] = 0;
   end
   
module
