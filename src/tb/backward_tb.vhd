---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : backward_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Nov 30 2017       @Modified Date : Nov 30 2017 05:47
-- @Project         : Artificial Neural Network
-- @Module          : backward_tb
-- @Description     : Test bias with some input
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
library ieee;
use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;
use work.tb_pkg.all;

---------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------
entity backward_tb is
end;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of backward_tb is
    -- component declaration
    component backward is
        port (
            clk                   : in  std_logic;
            areset                : in  std_logic;
            i_input               : in  input_array_t(layer_input_size - 1 downto 0);
            i_expected            : in  input_array_t(layer_input_size - 1 downto 0);
            i_weight_output       : in  weight_array2_hidden2output_t;
            i_activation_output   : in  activation_array_t(layer_output_size - 1 downto 0);
            i_activation_hidden   : in  activation_array_t(layer_hidden_size - 1 downto 0);

            o_adder_weight_output : out weight_array2_hidden2output_t;
            o_adder_weight_hidden : out weight_array2_input2hidden_t;
            o_adder_bias_output   : out bias_array_t(layer_output_size - 1 downto 0);
            o_adder_bias_hidden   : out bias_array_t(layer_hidden_size - 1 downto 0)
        );
    end component;

    -- signal declaration
    signal clk                   : std_logic := '0';
    signal areset                : std_logic := '1';
    signal i_input               : input_array_t(layer_input_size - 1 downto 0)
                                    := (others => (others => '0'));
    signal i_expected            : input_array_t(layer_input_size - 1 downto 0)
                                    := (others => (others => '0'));
    signal i_weight_output       : weight_array2_hidden2output_t
                                    := (others => (others => (others => '0')));
    signal i_activation_output   : activation_array_t(layer_output_size - 1 downto 0)
                                    := (others => (others => '0'));
    signal i_activation_hidden   : activation_array_t(layer_hidden_size - 1 downto 0)
                                    := (others => (others => '0'));
    signal o_adder_weight_output : weight_array2_hidden2output_t
                                    := (others => (others => (others => '0')));
    signal o_adder_weight_hidden : weight_array2_input2hidden_t
                                    := (others => (others => (others => '0')));
    signal o_adder_bias_output   : bias_array_t(layer_output_size - 1 downto 0)
                                    := (others => (others => '0'));
    signal o_adder_bias_hidden   : bias_array_t(layer_hidden_size - 1 downto 0)
                                    := (others => (others => '0'));

    constant period  : time := 100 ns;
begin
    -- device unit test
    dut: backward port map ( clk                 => clk,
                           areset                => areset,
                           i_input               => i_input,
                           i_expected            => i_expected,
                           i_weight_output       => i_weight_output,
                           i_activation_output   => i_activation_output,
                           i_activation_hidden   => i_activation_hidden,
                           o_adder_weight_output => o_adder_weight_output,
                           o_adder_weight_hidden => o_adder_weight_hidden,
                           o_adder_bias_output   => o_adder_bias_output,
                           o_adder_bias_hidden   => o_adder_bias_hidden );

    clk <= not(clk) after period / 2;
    areset <= '0' after period;

     stimulus: process
    begin
        wait until areset = '0';

        -- Main simulation
        test_case_backward ( clk, 8.0, 8.0, 1.0, 0.0,
            0.7, 0.2, 0.2, 0.5, 1.3, 1.1,
            0.7601, 0.6851,
            0.9526, 0.9955, 0.99,
            i_input, i_expected, i_weight_output,
            i_activation_output, i_activation_hidden);

        test_case_backward ( clk, 8.0, 5.0, 0.0, 1.0,
            0.7, 0.2, 0.2, 0.5, 1.3, 1.1,
            0.7464, 0.6785,
            0.8581, 0.9802, 0.09866,
            i_input, i_expected, i_weight_output,
            i_activation_output, i_activation_hidden);

        test_case_backward ( clk, 5.0, 8.0, 0.0, 1.0,
            0.7, 0.2, 0.2, 0.5, 1.3, 1.1,
            0.7463, 0.6724,
            0.9370, 0.9890, 0.9427,
            i_input, i_expected, i_weight_output,
            i_activation_output, i_activation_hidden);

        test_case_backward ( clk, 5.0, 5.0, 0.0, 1.0,
            0.7, 0.2, 0.2, 0.5, 1.3, 1.1,
            0.724, 0.6584,
            0.8176, 0.9526, 0.9241,
            i_input, i_expected, i_weight_output,
            i_activation_output, i_activation_hidden);
        --finish(2);
    end process;
end;
