##############################################################################
# Project name   :
# File name      : Makefile
# Last modified  : xim 29 2017 16:15
# Guide          : Edit compile.do for other simulation
###############################################################################
.PHONY: all sim init clean

TARGET   := compile.do
LANG     := vhd
COMPILE  := vcom
SIMULATE := vsim

vpath %.vhd ../rtl ../tb

SRCS := $(wildcard ../rtl/*.$(LANG))
TB   := $(wildcard ../tb/*.$(LANG))


all:
	@$(COMPILE) ../rtl/rtl_pkg.vhd
	@$(COMPILE) $(SRCS)
	@$(SIMULATE) -c -do $(TARGET)

init:
	vlib work
	
run:
	@$(SIMULATE) -do $(TARGET)

clean:
	@-rm -rf work/ modelsim.ini transcript vsim.wlf w* ../rtl/modelsim.init ../tb/modelsim.ini
