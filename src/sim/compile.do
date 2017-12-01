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

#vcom -check_synthesis ../rtl/backward.vhd
#vcom -check_synthesis ../tb/backward_tb.vhd
#vsim backward_tb

vcom ../rtl/delta_bias_cumulation.vhd
vcom ../tb/delta_bias_cumulation_tb.vhd
vsim delta_bias_cumulation_tb

add wave -radix decima *
add wave -radix decima -group dut dut/*
config wave -signalnamewidth 1
log -r /*
run 1000 ns
exit
