module example_logic(switch_inputs, led_outputs);
   input [3:0] switch_inputs;
   output [3:0]	led_outputs;
   
   assign led_outputs[0] = &switch_inputs;
   assign led_outputs[1] = |switch_inputs;
   assign led_outputs[2] = ^switch_inputs;
endmodule 
