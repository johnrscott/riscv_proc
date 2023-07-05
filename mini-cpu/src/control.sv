module control(output reg is_branch, mem_to_reg, 
	       reg_write, mem_read, mem_write,
	       alu_src,
	       output reg [2:0] alu_ctrl,
	       input [31:0] instr);

   localparam OPCODE_ADD_SUB_AND_OR = 7'd51;
   localparam OPCODE_LD = 7'd3;
   localparam OPCODE_SD = 7'd35;
   localparam OPCODE_BEQ = 7'd99;
   
   localparam FUNCT3_ADD_SUB = 3'd0;
   localparam FUNCT3_AND = 3'd7;
   localparam FUNCT3_OR = 3'd6;
   
   localparam FUNCT7_ADD = 7'd0;
   localparam FUNCT7_SUB = 7'd32;
   
   wire [6:0] 		    opcode, funct7;
   wire [2:0] 		    funct3;
   
   // R-type instruction layout
   assign opcode = instr[6:0];
   assign funct3 = instr[14:12];
   assign funct7 = instr[31:25];
   
   always @(*) begin

      is_branch = 0;
      mem_to_reg = 'x;
      reg_write = 0;
      mem_read = 'x;
      mem_write = 0;
      alu_src = 0;
      alu_ctrl = 'x;
      
      case (opcode)
        OPCODE_ADD_SUB_AND_OR: begin
	   mem_to_reg = 0;
	   reg_write = 1;
	   if (funct3 == FUNCT3_ADD_SUB) begin
	     if (funct7 == FUNCT7_ADD)
	       alu_ctrl = 3'b010;
	     else if (funct7 == FUNCT7_SUB)
	       alu_ctrl = 3'b110;
	   end
	   else if (funct3 == FUNCT3_AND)
	     alu_ctrl = 3'b000;
	   else if (funct3 == FUNCT3_OR)
	     alu_ctrl = 3'b001;
	end
	OPCODE_LD: begin
	   mem_to_reg = 1;
	   reg_write = 1;
	   mem_read = 1;
	   alu_src = 1;
	   alu_ctrl = 3'b010;
	end
	OPCODE_SD: begin
	   mem_write = 1;
	   alu_src = 1;
	   alu_ctrl = 3'b010;
	end
	OPCODE_BEQ: begin
	   is_branch = 1;
	   alu_ctrl = 3'b110;
	end
      endcase
   end

endmodule
