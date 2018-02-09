<!---
/*******************************************************************************
// Project name   :
// File name      : README.md
// Created date   : Nov 22 2017
// Author         : Huy-Hung Ho
// Last modified  : Nov 22 2017 17:47
// Desc           :
*******************************************************************************/
-->

# INTRO

Files and directories:
-   cpp/
-   matlab/
-   rtl/
-   script/
-   sim/
-   tb/
-   verilog/
-   README.md

# REQUIREMENT

- modelsim/questasim
- makefile

# HOW TO RUN

Edit $TARGET variable in ./sim/Makefile

Compile and debug
	cd sim; make init; make

Simulation
	cd sim; make init; make sim

TOP_ANN core simulation
	cd sim; vsim vhdl.wlf
