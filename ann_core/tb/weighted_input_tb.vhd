---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
-- -- Copyright notification -- No part may be reproduced except as authorized by written permission.
--
-- @File            : weighted_input_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : kax 01 2017       @Modified Date : kax 01 2017 16:29
-- @Project         : Artificial Neural Network
-- @Module          : weighted_input_tb
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
entity weighted_input_tb is
end entity;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of weighted_input_tb is
    -- component declaration
    component weighted_input
        generic (
            layer_size       : integer := 2
        );
        port (
            clk              : in  std_logic;
            reset            : in  std_logic;
            i_input_array    : in  input_array_t(layer_size - 1 downto 0);
            i_weight_array   : in  weight_array_t(layer_size - 1 downto 0);
            i_bias_hidden    : in  bias_float_t;
            o_weighted_input : out weighted_input_float_t
        );
    end component weighted_input;

    -- signal declaration
    constant layer_size         : integer := 2;
    signal s_i_input_array    : input_array_t(layer_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_i_weight_array   : weight_array_t(layer_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_i_bias_hidden    : bias_float_t := (others => '0');
    signal s_o_weighted_input : weighted_input_float_t := (others => '0');
    signal s_clk              : std_logic := '0';
    signal s_reset            : std_logic := '1';
    constant period           : time := 100 ns;
begin
    -- device unit test
    dut: weighted_input
    generic map (
       layer_size        => layer_size       
    )
    port map (
       clk               => s_clk,
       reset             => s_reset ,
       i_input_array     => s_i_input_array,
       i_weight_array    => s_i_weight_array,
       i_bias_hidden     => s_i_bias_hidden,
       o_weighted_input  => s_o_weighted_input 
    );

    s_clk <= not(s_clk) after period / 2;
    s_reset  <= '0'     after period;

    stimulus: process
    begin
        wait until s_reset  = '0';

    -- -- Main simulation
    test_case_error_hidden (s_clk, 1.5, -5.0, -0.2, 5.4, 2.1,
        s_o_weighted_input, -41.1,
        s_i_bias_hidden, s_i_input_array, s_i_weight_array);
    end process;
end bench;
