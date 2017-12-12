##############################################################################
# Project name   :
# File name      : Makefile
# Last modified  : xim 29 2017 16:15
# Guide          : run make sim_top & dataset open/reload
###############################################################################

TARGET   := top_ann_tb
LANG     := vhd
COMPILE  := vcom
SIMULATE := vsim
CHECK_COMMAND   := "log -r /*; run 1000 ns; exit;"
SIM_COMMAND     := "add wave -radix decima dut/*; add wave -radix decima -group tb *; config wave -signalnamewidth 1; log -r /*; run 1000 ns;"
TOP_SIM_COMMAND := "log -r /*; run -all; exit;"

VSIM_OPTS=-c -t 1ps -wlf vhdl.wlf

vpath %.vhd ../rtl ../tb

SRCS := $(wildcard ../rtl/*.$(LANG))
TB   := $(wildcard ../tb/*.$(LANG))

all: $(TARGET)
	@$(SIMULATE) -c $(TARGET) -do $(CHECK_COMMAND)

sim: $(TARGET)
	@$(SIMULATE) $(TARGET) -do $(SIM_COMMAND)

sim_top: $(TARGET)
	@$(SIMULATE) $(VSIM_OPTS) $(TARGET) -do $(TOP_SIM_COMMAND)

init:
	vlib work

top_ann_tb: forward_tb backward_tb
	@$(COMPILE) ../rtl/top_ann.vhd
	@$(COMPILE) ../tb/top_ann_tb.vhd


forward_tb: forward_module
	@$(COMPILE) ../rtl/forward.vhd
	@$(COMPILE) ../tb/tb_pkg.vhd
	@$(COMPILE) ../tb/forward_tb.vhd

backward_tb: backward_module
	@$(COMPILE) ../rtl/backward.vhd
	@$(COMPILE) ../tb/tb_pkg.vhd
	@$(COMPILE) ../tb/backward_tb.vhd

forward_module: init
	@$(COMPILE) ../rtl/rtl_pkg.vhd
	@$(COMPILE) ../rtl/weight.vhd
	@$(COMPILE) ../rtl/bias.vhd
	@$(COMPILE) -2008 ../rtl/weighted_input.vhd
	@$(COMPILE) ../rtl/activation_funct.vhd

backward_module: init
	@$(COMPILE) ../rtl/derivative_activation.vhd
	@$(COMPILE) ../rtl/error_ouput.vhd
	@$(COMPILE) ../rtl/error_hidden.vhd
	@$(COMPILE) ../rtl/delta_bias.vhd
	@$(COMPILE) ../rtl/delta_weight.vhd
	@$(COMPILE) ../rtl/delta_bias_cumulation.vhd
	@$(COMPILE) ../rtl/delta_weight_cumulation.vhd

clean:
	@-rm -rf work/ modelsim.ini transcript vsim.wlf w* ../rtl/modelsim.ini ../tb/modelsim.ini

.PHONY: all sim clean init $(TARGET) forward_tb backward_tb forward_module backward_module
