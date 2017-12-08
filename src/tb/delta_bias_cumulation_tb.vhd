---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
-- -- Copyright notification -- No part may be reproduced except as authorized by written permission.
--
-- @File            : delta_bias_cumulation_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : kax 01 2017       @Modified Date : kax 01 2017 13:30
-- @Project         : Artificial Neural Network
-- @Module          : delta_bias_cumulation_tb
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
entity delta_bias_cumulation_tb is
end entity;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of delta_bias_cumulation_tb is
    -- component declaration
    component delta_bias_cumulation
        port (
            clk                    : in  std_logic;
            reset                  : in  std_logic;
            i_delta_bias           : in  bias_float_t;
            o_bias_cumulation      : out bias_float_t
        );
    end component delta_bias_cumulation;

    -- signal declaration
    signal s_i_delta_bias           :  bias_float_t := (others => '0');
    signal s_o_bias_cumulation      :  bias_float_t := (others => '0');
    signal s_clk      : std_logic := '0';
    signal s_reset    : std_logic := '1';
    constant period : time := 100 ns;
begin
    -- device unit test
    dut: delta_bias_cumulation
    port map (
       clk                     => s_clk,
       reset                   => s_reset ,
       i_delta_bias            => s_i_delta_bias,
       o_bias_cumulation       => s_o_bias_cumulation      
    );

    s_clk <= not(s_clk) after period / 2;
    s_reset  <= '0'     after period;

    stimulus: process
    begin
        wait until s_reset  = '0';

        -- -- Main simulation
        test_case_der_activ(s_clk, 1.5, s_o_bias_cumulation, -0.15, s_i_delta_bias);
        test_case_der_activ(s_clk, 2.5, s_o_bias_cumulation, -0.4, s_i_delta_bias);
        test_case_der_activ(s_clk, -1.0, s_o_bias_cumulation, -0.3, s_i_delta_bias);
        test_case_der_activ(s_clk, 2.0, s_o_bias_cumulation, -0.5, s_i_delta_bias);
        test_case_der_activ(s_clk, 7.0, s_o_bias_cumulation, -1.05, s_i_delta_bias);
    end process;
end bench;
