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

# HOW TO RUN

Insert file which need to simulation in ./sim/compile.do

Init library
	cd sim; make init

Simulation
	cd sim; make

Check error
	cd sim; make run

Compiler sub-module of forward
	cd sim; make forward

# TIP

Insert vimrc for simulation
	- Read ./script/insert_script_vim.sh
