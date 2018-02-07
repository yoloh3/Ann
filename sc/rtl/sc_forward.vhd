---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : sc_forward.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Feb 05 2018       @Modified Date : Feb 05 2018 09:32
-- @Project         : Artificial Neural Network
-- @Module          : sc_forward
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use work.sc_rtl_pkg.all;
use work.sc_tb_pkg.all;
---------------------------------------------------------------------------------
-- Entity declaration
---------------------------------------------------------------------------------
entity sc_forward is
    port
    (
        clk                 : in  std_logic;
        areset              : in  std_logic;
        i_start             : in  std_logic;

        i_input             : in  sc_array_t(0 to layer_input_size - 1);
        i_weight_hidden     : in  sc_array2_input2hidden_t;
        i_weight_output     : in  sc_array2_hidden2output_t;
        i_bias_hidden       : in  sc_array_t(0 to layer_hidden_size - 1);
        i_bias_output       : in  sc_array_t(0 to layer_output_size - 1);

        o_finish_calc       : out std_logic;
        o_activation_output : out sc_array_t(0 to layer_output_size - 1)
    );
end sc_forward;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture rtl of sc_forward is

    signal s_weighted_in_hidden : sc_array_t(0 to layer_hidden_size - 1);
    signal s_weighted_in_output : sc_array_t(0 to layer_output_size - 1);
    signal s_activ_funct_hidden : sc_array_t(0 to layer_hidden_size - 1);
    signal s_activ_funct_output : sc_array_t(0 to layer_output_size - 1);

    signal s_enab_w_hidden : std_logic;
    signal s_enab_a_hidden : std_logic;
    signal s_enab_w_output : std_logic;
    signal s_enab_a_output : std_logic;

    signal s_valid_out_hidden : std_logic_vector(0 to layer_hidden_size - 1);
    signal s_valid_out_output : std_logic_vector(0 to layer_output_size - 1);

    constant counter_w : integer := 10;
    constant max_count : integer := 514;
    signal counter : unsigned(counter_w - 1 downto 0);
    signal s_enable  : std_logic;
    signal s_finish  : std_logic;
begin

    -- Control
    s_enab_a_hidden <= AND(s_valid_out_hidden);
    s_enab_a_output <= AND(s_valid_out_output);

    controller: process(clk, areset)
    begin
        if(areset  = '0') then
            counter          <= (others => '0');
            s_enable         <= '0';
            s_finish         <= '0';
            s_enab_w_hidden  <= '0';
            s_enab_w_output  <= '0';
        elsif rising_edge(clk) then
            if (i_start = '1') then
                s_enable <= '1';
            elsif (s_finish = '1') then
                s_enable <= '0';
            end if;

            if s_enable = '1' then
                counter <= counter + 1;
            end if;

            s_enab_w_hidden <= i_start;
            s_enab_w_output <= s_enab_a_hidden;

            if s_enab_a_output = '1' then
                s_finish <= '1';
            else
                s_finish <= '0';
            end if;

         end if;
    end process controller;

    calc_hidden: for i in 0 to layer_hidden_size - 1 generate
        calc_weighted_in_hidden: entity work.sc_weighted_in_hidden 
        generic map (
          data_width     => sc_data_width
        )
        port map (
            clk          => clk,
            rst_n        => areset,
            start_in     => i_start,
            input1       => i_input(0),
            input2       => i_input(1),
            weight1      => i_weight_hidden(i)(0),
            weight2      => i_weight_hidden(i)(1),
            bias         => i_bias_hidden(i),
            valid_out    => s_valid_out_hidden(i),
            result_out   => s_weighted_in_hidden(i)
        );

        calc_activ_fuct_hidden: entity work.sc_sigmoid_hidden
        port map (
           clk                 => clk,
           areset              => areset,
           i_start             => s_enab_a_hidden,
           i_weighted_input    => s_weighted_in_hidden(i),
           o_sc_sigmoid        => s_activ_funct_hidden(i)
        );
    end generate calc_hidden;

     calc_output: for i in 0 to layer_output_size - 1 generate
        calc_weighted_in_output: entity work.sc_weighted_in_output 
        generic map (
          data_width     => sc_data_width
        )
        port map (
            clk          => clk,
            rst_n        => areset,
            start_in     => s_enab_w_output,
            input1       => s_activ_funct_hidden(0),
            input2       => s_activ_funct_hidden(1),
            input3       => s_activ_funct_hidden(2),
            weight1      => i_weight_output(i)(0),
            weight2      => i_weight_output(i)(1),
            weight3      => i_weight_output(i)(2),
            bias         => i_bias_output(i),
            valid_out    => s_valid_out_output(i),
            result_out   => s_weighted_in_output(i)
        );

        calc_activ_fuct_output: entity work.sc_sigmoid
        port map (
           clk                 => clk,
           areset              => areset,
           i_start             => s_enab_a_output,
           i_weighted_input    => s_weighted_in_output(i),
           o_sc_sigmoid        => s_activ_funct_output(i)
        );
    end generate calc_output;

    o_finish_calc <= s_finish;
    o_activation_output <= s_activ_funct_output;
end rtl;
