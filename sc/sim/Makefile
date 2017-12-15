all: sc_mul_example
RTL_DIR := ../rtl
TB_DIR := ../tb
sc_mul_example:
	vlib work
	vcom -2008 $(RTL_DIR)/lfsr.vhd
	vcom $(RTL_DIR)/sng.vhd
	vcom -2008 $(RTL_DIR)/sc_mul_example.vhd
	vcom $(TB_DIR)/sc_mul_example_tb.vhd
	vsim -novopt -wlf sc_mul_example.wlf sc_mul_example_tb -c -do "log -r /*; run -a; exit;"
