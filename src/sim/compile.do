# -----------------------------------------------------------------------------
# Project name   :
# File name      : compile.do
# Created date   : Nov 23 2017
# Author         : Huy-Hung Ho
# Last modified  : Nov 23 2017 11:59
# Guide          :
# -----------------------------------------------------------------------------

## Some trick
# dataset reload -f


## Script

vcom -check_synthesis ../rtl/rtl_pkg.vhd
vcom -check_synthesis ../tb/tb_pkg.vhd

vcom -check_synthesis ../rtl/forward.vhd
vcom -check_synthesis ../tb/forward_tb.vhd
vsim forward

#vcom ../rtl/weighted_input.vhd
#vcom ../tb/weighted_input_tb.vhd
#vsim weighted_input_tb

add wave -radix decima *
add wave -radix decima -group dut dut/*
config wave -signalnamewidth 1
log -r /*
run 1000 ns
exit
