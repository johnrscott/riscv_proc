module uart_tx_control
  #(parameter one_hot_count = 3, state_count = one_hot_count, size_bit_count = 3,
    idle = 3'b001, waiting = 3'b010, sending = 3'b100, all_ones = 9'b1_1111_1111)
   (output reg load_xmt_datareg_out, load_xmt_shiftreg, start, shift, clear,
    input load_xmt_datareg, byte_ready, t_byte, bc_lt_bcmax, clk, rst_b);
   
   reg [state_count-1:0] state, next_state;
   
   // The control path consists of two parts; a combinational
   // logic part that computes the outputs and the next state
   // (this behaviour) and an edge sensitive behaviour (the one
   // below) that loads the next state
   always @(*) begin: output_and_next_state
      load_xmt_datareg_out = 0;
      load_xmt_shiftreg = 0;
      start = 0;
      shift = 0;
      clear = 0;
      next_state = idle;

      case (state)
	idle: 
	  if (load_xmt_datareg == 1'b1) begin
	     load_xmt_datareg_out = 1;
	     next_state = idle;
	  end
	  else if (byte_ready == 1'b1) begin
	     load_xmt_shiftreg = 1;
	     next_state = waiting;
	  end
	waiting:
	  if (t_byte == 1) begin
	     start = 1;
	     next_state = sending;
	  end
	  else begin
	     clear = 1;
	     next_state = idle;
	  end
	default:
	  next_state = idle;
      endcase
   end // block: output_and_next_state

   // Load the next state at the rising clock edge, or reset
   always @(posedge clk, negedge rst_b) begin: state_transitions
      if (rst_b == 1'b0)
	state <= idle;
      else state <= next_state;
   end
   
endmodule
   
