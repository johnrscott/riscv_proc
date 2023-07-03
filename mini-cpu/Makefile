run_testbench: testbench/testbench
	vvp testbench/testbench

testbench/testbench: src/*.v
	mkdir -p testbench
	iverilog -o $@ -s testbench $^

