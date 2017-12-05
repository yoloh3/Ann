---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
-- -- Copyright notification -- No part may be reproduced except as authorized by written permission.
--
-- @File            : forward_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : kax 01 2017       @Modified Date : kax 01 2017 18:20
-- @Project         : Artificial Neural Network
-- @Module          : forward_tb
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
entity forward_tb is
end entity;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of forward_tb is
    -- component declaration
    component forward
        port (
            clk                   : in  std_logic;
            areset                : in  std_logic;
            i_din                 : in  std_logic;
            i_select_initial      : in  std_logic;
            i_input               : in  input_array_t(layer_input_size - 1 downto 0);
            i_expected            : in  input_array_t(layer_input_size - 1 downto 0);
            i_adder_weight_hidden : in  weight_array2_input2hidden_t;
            i_adder_weight_output : in  weight_array2_hidden2output_t;
            i_adder_bias_hidden   : in  bias_array_t(layer_hidden_size - 1 downto 0);
            i_adder_bias_output   : in  bias_array_t(layer_output_size - 1 downto 0);
            o_weight_hidden       : out weight_array2_input2hidden_t;
            o_weight_output       : out weight_array2_hidden2output_t;
            o_activation_hidden   : out activation_array_t(layer_hidden_size - 1 downto 0);
            o_activation_output   : out activation_array_t(layer_output_size - 1 downto 0)
        );
    end component forward;

    -- signal declaration
    signal s_i_din                 :   std_logic;
    signal s_i_select_initial      :   std_logic;
    signal s_i_input               :   input_array_t(layer_input_size - 1 downto 0);
    signal s_i_expected            :   input_array_t(layer_input_size - 1 downto 0);
    signal s_i_adder_weight_hidden :   weight_array2_input2hidden_t;
    signal s_i_adder_weight_output :   weight_array2_hidden2output_t;
    signal s_i_adder_bias_hidden   :   bias_array_t(layer_hidden_size - 1 downto 0);
    signal s_i_adder_bias_output   :   bias_array_t(layer_output_size - 1 downto 0);
    signal s_o_weight_hidden       :  weight_array2_input2hidden_t;
    signal s_o_weight_output       :  weight_array2_hidden2output_t;
    signal s_o_activation_hidden   :  activation_array_t(layer_hidden_size - 1 downto 0);
    signal s_o_activation_output   :  activation_array_t(layer_output_size - 1 downto 0);
    --signal s_finish_update         :  std_logic;
    signal s_clk      : std_logic := '0';
    signal s_areset   : std_logic := '1';
    constant period   : time := 100 ns;
begin
    -- device unit test
    dut: forward
    port map (
       clk                    => s_clk,
       areset                 => s_areset,
       i_din                  => s_i_din,
       i_select_initial       => s_i_select_initial,
       i_input                => s_i_input,
       i_expected             => s_i_expected,
       i_adder_weight_hidden  => s_i_adder_weight_hidden,
       i_adder_weight_output  => s_i_adder_weight_output,
       i_adder_bias_hidden    => s_i_adder_bias_hidden,
       i_adder_bias_output    => s_i_adder_bias_output,
       o_weight_hidden        => s_o_weight_hidden,
       o_weight_output        => s_o_weight_output,
       o_activation_hidden    => s_o_activation_hidden,
       o_activation_output    => s_o_activation_output
       --finish_update          => s_finish_update         
    );

    s_clk     <= not(s_clk)   after period / 2;
    s_areset  <= '0'          after period;
    s_i_din   <= '1'          after 2 * period;
    s_i_select_initial <= '1' after 3 * period;

    stimulus: process
    begin
        wait until s_areset = '0';

        -- -- Main simulation
    test_case_forward ( s_clk, 8.0, 8.0, 1.0, 1.0,
            -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, 
            -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, 
            -1.0, -1.0, -1.0, -1.0, 
            s_i_input, s_i_expected,
            s_i_adder_weight_hidden, s_i_adder_weight_output,
            s_i_adder_bias_hidden, s_i_adder_bias_output
    );

    end process;
end bench;
