
####################################################################################
# Generated by Vivado 2017.3 built on 'Wed Oct  4 19:58:07 MDT 2017' by 'xbuild'
# Command Used: write_xdc -no_fixed_only -force ./nn_core_vc707/nn_core_impl.xdc
####################################################################################


####################################################################################
# Constraints from file : 'nn_core_vc707.xdc'
####################################################################################

## simple constraint for evaluation

create_clock -period 10.850 -name clk [get_ports clk]
create_clock -period 10.850 -name virtual_clk


# Vivado Generated miscellaneous constraints 

#revert back to original instance
current_instance -quiet
