all: sc_add_example
RTL_DIR := ../rtl
TB_DIR := ../tb
common:
	vlib work
	vcom -2008 $(RTL_DIR)/lfsr.vhd
	vcom $(RTL_DIR)/sng.vhd
	vcom $(TB_DIR)/sc_tb_pkg.vhd

sc_mul_example: common
	vcom -2008 $(RTL_DIR)/sc_mul_example.vhd
	vcom $(TB_DIR)/sc_mul_example_tb.vhd
	vsim -novopt -wlf sc_mul_example.wlf sc_mul_example_tb \
		-c -do "log -r /*; run -a; exit;"

sc_mul: common
	vcom -2008 $(RTL_DIR)/sc_mul.vhd
	vcom -2008 $(TB_DIR)/sc_mul_tb.vhd
	vsim -novopt -wlf sc_mul.wlf sc_mul_tb \
		-c -do "log -r /*; run -a; exit;"
sc_add_example:
	vcom -2008 $(RTL_DIR)/sc_add_example.vhd
	vcom -2008 $(TB_DIR)/sc_add_example_tb.vhd
	vsim -novopt -wlf sc_add_example.wlf sc_add_example_tb \
		-c -do "log -r /*; run -a; exit;"
