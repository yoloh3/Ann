---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
-- -- Copyright notification -- No part may be reproduced except as authorized by written permission.
--
-- @File            : delta_bias_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : kax 01 2017       @Modified Date : kax 01 2017 13:06
-- @Project         : Artificial Neural Network
-- @Module          : delta_bias_tb
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
library ieee;
use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.numeric_std.all;
use work.rtl_pkg.all;
use work.tb_pkg.all;

---------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------
entity delta_bias_tb is
end entity;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of delta_bias_tb is
    -- component declaration
    component delta_bias
        port (
            clk               : in  std_logic;
            reset             : in  std_logic;
            i_error           : in  error_float_t;
            o_delta_bias      : out weight_float_t
        );
    end component delta_bias;

    -- signal declaration
	signal s_clk            : std_logic := '0';
    signal s_reset          : std_logic := '1';
    signal s_i_error      : error_float_t := (others => '0');
    signal s_o_delta_bias : weight_float_t := (others => '0');
    constant period       : time := 100 ns;
begin
    -- device unit test
    dut: delta_bias port map (
           clk             => s_clk,
           reset           => s_reset ,
           i_error         => s_i_error,
           o_delta_bias    => s_o_delta_bias   
    );

    s_clk <= not(s_clk) after period / 2;
    s_reset  <= '0'     after period;

    stimulus: process
    begin
        wait until s_reset  = '0';

        -- -- Main simulation
        test_case_der_activ(s_clk,  1.5, s_o_delta_bias,  1.5, s_i_error);
        test_case_der_activ(s_clk, -0.7, s_o_delta_bias, -0.7, s_i_error);
    end process;
end bench;
