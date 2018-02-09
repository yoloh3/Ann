all: sc_forward 
RTL_DIR := ../rtl
TB_DIR := ../tb

init:
	vlib work
	vmap work work
	vcom -2008 $(RTL_DIR)/lfsr.vhd \
	           $(RTL_DIR)/sng.vhd \
	           $(RTL_DIR)/sc_rtl_pkg.vhd \
	           $(TB_DIR)/sc_tb_pkg.vhd

sc_mul:
	vcom -2008 $(RTL_DIR)/sc_mul.vhd \
			   $(TB_DIR)/sc_mul_tb.vhd
	vsim -novopt -wlf sc_mul.wlf sc_mul_tb \
		-c -do "log -r /*; run -a; exit;"

sc_mul_bipolar:
	vcom -2008 $(RTL_DIR)/sc_mul_bipolar.vhd \
			   $(TB_DIR)/sc_mul_bipolar_tb.vhd
	vsim -novopt -wlf sc_mul_bipolar.wlf sc_mul_bipolar_tb \
		-c -do "log -r /*; run -a; exit;"

sc_add:
	vcom -2008 $(RTL_DIR)/sc_add.vhd \
			   $(TB_DIR)/sc_add_tb.vhd
	vsim -novopt -wlf sc_add.wlf sc_add_tb \
		-c -do "log -r /*; run -a; exit;"

sc_add_bipolar:
	vcom -2008 $(RTL_DIR)/sc_add_bipolar.vhd \
			   $(TB_DIR)/sc_add_bipolar_tb.vhd
	vsim -novopt -wlf sc_add_bipolar.wlf sc_add_bipolar_tb \
		-c -do "log -r /*; run -a; exit;"

sc_weighted_in_hidden:
	vcom -2008 $(RTL_DIR)/sc_weighted_in_hidden.vhd \
			   $(TB_DIR)/sc_weighted_in_hidden_tb.vhd
	vsim -novopt -wlf sc_weighted_in_hidden.wlf sc_weighted_in_hidden_tb \
		-c -do "log -r /*; run -a; exit;"

sc_weighted_in_output:
	vcom -2008 $(RTL_DIR)/sc_sigmoid.vhd \
			   $(RTL_DIR)/sc_weighted_in_output.vhd \
			   $(TB_DIR)/sc_weighted_in_output_tb.vhd
	vsim -novopt -wlf sc_weighted_in_output.wlf sc_weighted_in_output_tb \
		-c -do "log -r /*; run -a; exit;"


sc_forward:  sc_weighted_in_output sc_weighted_in_hidden
	vcom -2008 $(RTL_DIR)/sc_rtl_pkg.vhd \
	           $(TB_DIR)/sc_tb_pkg.vhd \
	           $(RTL_DIR)/sc_sigmoid_hidden.vhd \
	           $(RTL_DIR)/sc_sigmoid.vhd \
	           $(RTL_DIR)/sc_forward.vhd \
	           $(TB_DIR)/sc_forward_tb.vhd
	vsim -novopt -wlf sc_forward.wlf sc_forward_tb \
		-c -do "log -r /*; run -a; exit;"

fw:
	vcom -2008 $(RTL_DIR)/sc_forward.vhd \
			   $(TB_DIR)/sc_forward_tb.vhd
	vsim -novopt -wlf sc_forward.wlf sc_forward_tb \
		-c -do "log -r /*; run -a; exit;"

clean:
	rm -rf ../rtl/modelsim.ini ../tb/modelsim.ini ../sim/modelsim.ini ../sim/transcipt ../sim/work/ ../sim/transcript
