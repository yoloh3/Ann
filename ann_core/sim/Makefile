##############################################################################
# Project name   :
# File name      : Makefile
# Last modified  : Dec 14 2017 10:33
# Guide          : run make sim_top & dataset open/reload
###############################################################################

TARGET       := top_ann_tb
RTL_DIR      := ../rtl
TB_DIR       := ../tb
VSIM_OPTS    := -c -t 1ps -wlf vhdl.wlf
RUN_COMMAND  := "log -r /*; run -all; exit;"
SIM_COMMAND  := "add wave -radix decima dut/*; add wave -radix decima -group tb *; config wave -signalnamewidth 1; log -r /*; run 1000 ns;"

all: sim_top

sim: $(TARGET)
	vsim $(TARGET) -do $(SIM_COMMAND)

sim_top: $(TARGET)
	vsim $(VSIM_OPTS) $(TARGET) -do $(RUN_COMMAND)

init:
	vlib work
	vcom $(RTL_DIR)/rtl_pkg.vhd \
		 $(TB_DIR)/tb_pkg.vhd

top_ann_tb: forward_module backward_module
	vcom $(RTL_DIR)/forward.vhd \
		 $(RTL_DIR)/backward.vhd \
		 $(RTL_DIR)/top_ann.vhd \
	     $(TB_DIR)/top_ann_tb.vhd

forward_tb: forward_module
	vcom $(TB_DIR)/tb_pkg.vhd \
		 $(RTL_DIR)/forward.vhd \
	     $(TB_DIR)/forward_tb.vhd

backward_tb: backward_module
	vcom $(RTL_DIR)/backward.vhd \
	     $(TB_DIR)/tb_pkg.vhd \
	     $(TB_DIR)/backward_tb.vhd

forward_module:
	vcom $(RTL_DIR)/weight.vhd \
	     $(RTL_DIR)/bias.vhd \
	     -2008 $(RTL_DIR)/weighted_input.vhd \
		 $(TB_DIR)/tb_pkg.vhd \
	     $(RTL_DIR)/activation_funct.vhd

backward_module:
	vcom $(RTL_DIR)/derivative_activation.vhd \
		 $(RTL_DIR)/error_ouput.vhd \
		 $(RTL_DIR)/error_hidden.vhd \
		 $(RTL_DIR)/delta_bias.vhd \
		 $(RTL_DIR)/delta_weight.vhd \
		 $(RTL_DIR)/delta_bias_cumulation.vhd \
		 $(RTL_DIR)/delta_weight_cumulation.vhd
activation_funct: init
	vcom $(RTL_DIR)/activation_funct.vhd
	vcom $(TB_DIR)/activation_tb.vhd
clean:
	rm -rf work/ modelsim.ini transcript vsim.wlf $(RTL_DIR)/modelsim.ini $(TB_DIR)/modelsim.ini
