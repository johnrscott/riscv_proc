module processor();

   localparam OPCODE_ADD_SUB_AND_OR = 7'd51;
   localparam OPCODE_LD = 7'd3;
   localparam OPCODE_SD = 7'd35;
   localparam OPCODE_BEQ = 7'd99;
   
   localparam FUNCT3_ADD_SUB = 3'd0;
   localparam FUNCT3_AND = 3'd6;
   localparam FUNCT3_OR = 3'd7;
   localparam FUNCT7_ADD = 7'd0;
   localparam FUNCT7_SUB = 7'd32;
   
   wire [6:0] 		    opcode, funct7;
   wire [2:0] 		    funct3;
   wire [4:0] 		    rd, rs1, rs2;
   
   // R-type instruction layout
   assign opcode = instr[6:0];
   assign rd = instr[11:7];
   assign funct3 = instr[14:12];
   assign rs1 = instr[19:15];
   assign rs2 = instr[24:20];
   assign funct7 = instr[31:25];



endmodule
