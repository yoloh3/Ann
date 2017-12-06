run:
	vlib work
	vlog ../rtl/*.v
	vlog ../testbench/*.v
	vsim -novopt NN_CORE_tb -c -do 'log -r /*; run -a; exit;'
