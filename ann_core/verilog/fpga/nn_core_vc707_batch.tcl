# vc707 batch implemenation of neuron network core from LSI Contest 2018
# part: xc7vx485tffg1761-2
# run the script: vivado -mode tcl -source vc707_batch.tcl

set output_dir ./nn_core_vc707
file mkdir $output_dir

## step 1 read designs & constraints
read_verilog [glob ../rtl/*.v]
read_xdc ./nn_core_vc707.xdc

## step 2 run synthesis
synth_design -top NN_CORE -part xc7vx485tffg1761-2 -flatten rebuilt
write_checkpoint -force $output_dir/post_synth

## Step 3 run placement and logic optimization, report utilization and timing
##        estimation
opt_design
power_opt_design
place_design
phys_opt_design
write_checkpoint -force $output_dir/post_place
report_timing_summary -file $output_dir/post_place_timing_summary.rpt

## Step 4: run router, report actual utilization and timing, write checkpoint
##         design, run drc, write verilog and xdc out
route_design
write_checkpoint -force $output_dir/post_route
report_timing_summary -file $output_dir/post_route_timing_summary.rpt

report_timing -sort_by group -max_paths 100 -path_type summary -file $output_dir/post_route_timing_timing.rpt

report_clock_utilization -file $output_dir/clock_util.rpt
report_utilization -file $output_dir/post_route_utilization.rpt
report_drc -file $output_dir/post_imp_drc.rpt
write_verilog -force $output_dir/nn_core_impl_netlist.v
write_xdc -no_fixed_only -force $output_dir/nn_core_impl.xdc

## step 5: generate bitstream
# write_bitstream -force $output_dir/nn_core.bit




