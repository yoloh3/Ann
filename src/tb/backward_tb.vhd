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
    component backward
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

end component backward;
    -- signal declaration
    signal clk                     : std_logic := '0';
    signal areset                  : std_logic := '1';
    signal s_i_input               : input_array_t(layer_input_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_i_expected            : input_array_t(layer_input_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_i_weight_output       : weight_array2_hidden2output_t
        := (others => (others => (others => '0')));
    signal s_i_activation_output   : activation_array_t(layer_output_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_i_activation_hidden   : activation_array_t(layer_hidden_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_o_adder_weight_output : weight_array2_hidden2output_t;
    signal s_o_adder_weight_hidden : weight_array2_input2hidden_t;
    signal s_o_adder_bias_output   : bias_array_t(layer_output_size - 1 downto 0);
    signal s_o_adder_bias_hidden   : bias_array_t(layer_hidden_size - 1 downto 0);

    constant period  : time := 10 ns;
begin
    -- device unit test
    dut: backward
        port map (
           clk                    => clk,
           areset                 => areset,
           i_input                => s_i_input,
           i_expected             => s_i_expected,
           i_weight_output        => s_i_weight_output,
           i_activation_output    => s_i_activation_output,
           i_activation_hidden    => s_i_activation_hidden,
           o_adder_weight_output  => s_o_adder_weight_output,
           o_adder_weight_hidden  => s_o_adder_weight_hidden,
           o_adder_bias_output    => s_o_adder_bias_output,
           o_adder_bias_hidden    => s_o_adder_bias_hidden
        );

    clk <= not(clk) after period / 2;
    areset <= '0' after 3 * period + period / 2;

     stimulus: process
    begin
        wait until areset = '0';

        -- Main simulation
        test1: test_case_backward (
            clk             => clk,
            i_input1        => 8.0,
            i_input2        => 8.0,
            i_expected1     => 1.0,
            i_expected2     => 0.0,
            i_weight_out11  => 0.7,
            i_weight_out21  => 0.2,
            i_weight_out31  => 1.3,
            i_weight_out12  => 0.2,
            i_weight_out22  => 0.5,
            i_weight_out32  => 1.1,
            i_acti_out1     => 0.7601,
            i_acti_out2     => 0.6851,
            i_acti_hid1     => 0.9526,
            i_acti_hid2     => 0.9955,
            i_acti_hid3     => 0.99,

            o_input         => s_i_input,
            o_expected      => s_i_expected,
            o_weight_output => s_i_weight_output,
            o_acti_out      => s_i_activation_output,
            o_acti_hid      => s_i_activation_hidden
        );

        test2: test_case_backward (
            clk             => clk,
            i_input1        => 8.0,
            i_input2        => 5.0,
            i_expected1     => 0.0,
            i_expected2     => 1.0,
            i_weight_out11  => 0.7,
            i_weight_out21  => 0.2,
            i_weight_out31  => 1.3,
            i_weight_out12  => 0.2,
            i_weight_out22  => 0.5,
            i_weight_out32  => 1.1,
            i_acti_out1     => 0.7464,
            i_acti_out2     => 0.6785,
            i_acti_hid1     => 0.8581,
            i_acti_hid2     => 0.9802,
            i_acti_hid3     => 0.9866,

            o_input         => s_i_input,
            o_expected      => s_i_expected,
            o_weight_output => s_i_weight_output,
            o_acti_out      => s_i_activation_output,
            o_acti_hid      => s_i_activation_hidden
        );

        test3: test_case_backward (
            clk             => clk,
            i_input1        => 5.0,
            i_input2        => 8.0,
            i_expected1     => 0.0,
            i_expected2     => 1.0,
            i_weight_out11  => 0.7,
            i_weight_out21  => 0.2,
            i_weight_out31  => 1.3,
            i_weight_out12  => 0.2,
            i_weight_out22  => 0.5,
            i_weight_out32  => 1.1,
            i_acti_out1     => 0.7463,
            i_acti_out2     => 0.6724,
            i_acti_hid1     => 0.9370,
            i_acti_hid2     => 0.9890,
            i_acti_hid3     => 0.9427,

            o_input         => s_i_input,
            o_expected      => s_i_expected,
            o_weight_output => s_i_weight_output,
            o_acti_out      => s_i_activation_output,
            o_acti_hid      => s_i_activation_hidden
        );

        test4: test_case_backward (
            clk             => clk,
            i_input1        => 5.0,
            i_input2        => 5.0,
            i_expected1     => 0.0,
            i_expected2     => 1.0,
            i_weight_out11  => 0.7,
            i_weight_out21  => 0.2,
            i_weight_out31  => 1.3,
            i_weight_out12  => 0.2,
            i_weight_out22  => 0.5,
            i_weight_out32  => 1.1,
            i_acti_out1     => 0.7240,
            i_acti_out2     => 0.6584,
            i_acti_hid1     => 0.8176,
            i_acti_hid2     => 0.9526,
            i_acti_hid3     => 0.9241,

            o_input         => s_i_input,
            o_expected      => s_i_expected,
            o_weight_output => s_i_weight_output,
            o_acti_out      => s_i_activation_output,
            o_acti_hid      => s_i_activation_hidden
        );
    end process;
end;
