---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
-- -- Copyright notification -- No part may be reproduced except as authorized by written permission.
--
-- @File            : error_hidden_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : kax 01 2017       @Modified Date : kax 01 2017 14:57
-- @Project         : Artificial Neural Network
-- @Module          : error_hidden_tb
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
entity error_hidden_tb is
end entity;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of error_hidden_tb is
    -- component declaration
    component error_hidden
        port (
            clk                  : in  std_logic;
            areset               : in  std_logic;
            i_dadz2              : in  dadz_float_t;
            i_weight_ouput_array : in  weight_array_t(layer_output_size - 1 downto 0);
            i_error_ouput_array  : in  error_array_t(layer_output_size - 1 downto 0);
            o_error_hidden       : out error_float_t
        );
    end component error_hidden;

    -- signal declaration
    signal s_i_dadz2              :   dadz_float_t := (others => '0');
    signal s_i_weight_ouput_array :   weight_array_t(layer_output_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_i_error_ouput_array  :   error_array_t(layer_output_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_o_error_hidden       :  error_float_t := (others => '0');
    signal s_clk      : std_logic := '0';
    signal s_areset   : std_logic := '1';
    constant period : time := 100 ns;
begin
    -- device unit test
    dut: error_hidden
    port map (
       clk                   => s_clk,
       areset                => s_areset,
       i_dadz2               => s_i_dadz2,
       i_weight_ouput_array  => s_i_weight_ouput_array,
       i_error_ouput_array   => s_i_error_ouput_array,
       o_error_hidden        => s_o_error_hidden       
    );

    s_clk <= not(s_clk) after period / 2;
    s_areset <= '0'     after period;

    stimulus: process
    begin
        wait until s_areset = '0';

        -- -- Main simulation
        test_case_error_hidden(s_clk, 1.5, -5.0, -0.2, 5.4, 2.1, s_o_error_hidden,
                                -41.13, s_i_dadz2, s_i_weight_ouput_array,
                                s_i_error_ouput_array);

    end process;
end bench;
