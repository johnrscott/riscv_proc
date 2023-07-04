run_testbench: testbench/testbench
	vvp testbench/testbench

wave: run_testbench
	gtkwave testbench/testbench.vcd

testbench/testbench: src/*.v
	mkdir -p testbench
	iverilog -o $@ -s testbench $^

