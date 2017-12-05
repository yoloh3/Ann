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

## Compiler module
#vcom ../rtl/weighted_input.vhd
#vcom ../tb/weighted_input_tb.vhd
#vsim weighted_input_tb

## Compile forward
vcom -check_synthesis ../rtl/rtl_pkg.vhd
vcom -check_synthesis ../rtl/forward.vhd
vsim forward


## Simulation testbench
#vcom -check_synthesis ../tb/tb_pkg.vhd
#vcom -check_synthesis ../tb/forward_tb.vhd

#add wave -radix decima *
#add wave -radix decima -group dut dut/*
#config wave -signalnamewidth 1
#log -r /*
#run 1000 ns
#exit
