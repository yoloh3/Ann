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

vcom ../tb/config_pkg.vhd
vcom ../rtl/bias.vhd
vcom ../tb/bias_tb.vhd

vsim bias_tb
#layout load Simulate
add wave -radix decima *
add wave -radix decima -group uut uut/*
config wave -signalnamewidth 1
log -r /*
run -a
exit
