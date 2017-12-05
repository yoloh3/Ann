##############################################################################
# Project name   :
# File name      : Makefile
# Last modified  : xim 29 2017 16:15
# Guide          : Edit compile.do for other simulation
###############################################################################
.PHONY: all sim clean init forward

TARGET   := compile.do
LANG     := vhd
COMPILE  := vcom
SIMULATE := vsim

vpath %.vhd ../rtl ../tb

SRCS := $(wildcard ../rtl/*.$(LANG))
TB   := $(wildcard ../tb/*.$(LANG))


sim: forward
	@$(SIMULATE) -c forward -do 'log -r /*; run 100ns'

init:
	vlib work
	
forward: init
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
