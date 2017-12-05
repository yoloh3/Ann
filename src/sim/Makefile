##############################################################################
# Project name   :
# File name      : Makefile
# Last modified  : xim 29 2017 16:15
# Guide          : Edit compile.do for other simulation
###############################################################################
.PHONY: all sim init clean forward

TARGET   := compile.do
LANG     := vhd
COMPILE  := vcom
SIMULATE := vsim

vpath %.vhd ../rtl ../tb

SRCS := $(wildcard ../rtl/*.$(LANG))
TB   := $(wildcard ../tb/*.$(LANG))


all:
	@$(SIMULATE) -c -do $(TARGET)

init:
	vlib work
	
forward:
	@$(COMPILE) ../rtl/rtl_pkg.vhd
	@$(COMPILE) ../rtl/weight.vhd
	@$(COMPILE) ../rtl/bias.vhd
	@$(COMPILE) ../rtl/weighted_input.vhd
	@$(COMPILE) ../rtl/activation_funct.vhd
	@$(COMPILE) ../rtl/forward.vhd

run:
	@$(SIMULATE) -do $(TARGET)

clean:
	@-rm -rf work/ modelsim.ini transcript vsim.wlf w* ../rtl/modelsim.init ../tb/modelsim.ini
