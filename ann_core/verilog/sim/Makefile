run:
	vlib work
	vlog ../rtl/*.v
	vlog ../testbench/*.v
	vsim -novopt -wlf verilog.wlf NN_CORE_tb -c -do 'log -r /*; run -a; exit;'
