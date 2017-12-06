## simple constraint for evaluation

create_clock -period 10.85 -name clk [get_ports clk]
create_clock -period 10.85 -name virtual_clk
set_false_path -from [get_ports res]
