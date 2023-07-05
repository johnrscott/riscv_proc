run_testbench: testbench/testbench
	vvp testbench/testbench

wave: run_testbench
	gtkwave testbench/testbench.vcd

testbench/testbench: src/*.sv
	mkdir -p testbench
	iverilog -g2005-sv -o $@ -s testbench $^
