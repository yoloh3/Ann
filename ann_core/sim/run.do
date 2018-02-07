##############################################################################
# Project name   :
# File name      : run.do
# Last modified  : Feb 02 2018 17:39
# Guide          :
###############################################################################

vlib work
vcom -2008 ../rtl/rtl_pkg.vhd ../tb/tb_pkg.vhd
vcom -2008 ../rtl/*.vhd ../tb/top_ann_tb.vhd
vsim -c -do "run -a; exit" top_ann_tb
