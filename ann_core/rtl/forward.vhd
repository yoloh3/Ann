---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by VLSI Systems Design Laboratory,
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_forward.vhd
-- @Author          : Xuan-Thuan Nguyen 	 @Modifier      : Huy-Hung Ho
-- @Created Date    : 17/11/2017      		 @Modified Date : kax 01 2017 16:00
-- @Project         : Library
-- @Module          : NN_forward
-- @Description     : Description of module.
-- @Version         : 0.1beta
-- @ID              : N/A
--
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.rtl_pkg.all;
---------------------------------------------------------------------------------
-- Entity declaration
---------------------------------------------------------------------------------
entity forward is
    port
    (
        clk                   : in  std_logic;
        areset                : in  std_logic;
        i_select_initial      : in  std_logic;
        i_update_coeff        : in  std_logic;
        i_input               : in  input_array_t(layer_input_size - 1 downto 0);

        i_adder_weight_hidden : in  weight_array2_input2hidden_t;
        i_adder_weight_output : in  weight_array2_hidden2output_t;
        i_adder_bias_hidden   : in  bias_array_t(layer_hidden_size - 1 downto 0);
        i_adder_bias_output   : in  bias_array_t(layer_output_size - 1 downto 0);

        o_finish_calc         : out std_logic;
        o_weight_hidden       : out weight_array2_input2hidden_t;
        o_weight_output       : out weight_array2_hidden2output_t;
        o_activation_hidden   : out activation_array_t(layer_hidden_size - 1 downto 0);
        o_activation_output   : out activation_array_t(layer_output_size - 1 downto 0)
    );
end forward;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture rtl of forward is
    component weight
        generic (
            init_value       : real := -1.0
        );
        port (
            clk              : in  std_logic;
            areset           : in  std_logic;
            i_select_initial : in  std_logic;
            i_select_update  : in  std_logic;
            i_dweight        : in  weight_float_t;
            o_weight         : out weight_float_t
        );
    end component weight;

    component bias
        generic (
            init_value       : real := -1.0
        );
        port (
            clk              : in  std_logic;
            areset           : in  std_logic;
            i_select_initial : in  std_logic;
            i_select_update  : in  std_logic;
            i_dbias          : in  bias_float_t;
            o_bias           : out bias_float_t
        );
    end component bias;

    component weighted_input
        generic (
            layer_size       : integer := 2
        );
        port (
            clk              : in  std_logic;
            areset           : in  std_logic;
            i_input          : in  activation_array_t(layer_size - 1 downto 0);
            i_weight         : in  weight_array_t(layer_size - 1 downto 0);
            i_bias           : in  bias_float_t;
            o_weighted_input : out weighted_input_float_t
        );
    end component weighted_input;

    component activation_funct
        port (
            clk                : in  std_logic;
            areset             : in  std_logic;
            i_weighted_input   : in  weighted_input_float_t;
            o_activation_funct : out activation_float_t
        );
    end component activation_funct;

    signal s_bias_hidden        : bias_array_t(layer_hidden_size - 1 downto 0);
    signal s_bias_output        : bias_array_t(layer_output_size - 1 downto 0);
    signal s_weight_hidden      : weight_array2_input2hidden_t;
    signal s_weight_output      : weight_array2_hidden2output_t;

    signal s_weighted_in_hidden : weighted_input_array_t(layer_hidden_size - 1 downto 0);
    signal s_weighted_in_output : weighted_input_array_t(layer_output_size - 1 downto 0);

    signal s_activ_funct_input  : activation_array_t(layer_input_size - 1 downto 0);
    signal s_activ_funct_hidden : activation_array_t(layer_hidden_size - 1 downto 0);
    signal s_activ_funct_output : activation_array_t(layer_output_size - 1 downto 0);

    constant counter_w       : integer := 8;
    constant max_count       : integer := 13;
    constant finish_count    : integer := 4;
    signal   counter         : unsigned(counter_w - 1 downto 0);
    signal   s_select_update : std_logic;
begin

    count: process(clk)
    begin
        if(areset  = '1') then
            counter <= (others => '0');
            o_finish_calc <= '0';
            s_select_update <= '0';
        elsif rising_edge(clk) then
            if (i_update_coeff = '1') then
                if counter = to_unsigned(finish_count, counter_w) then
                    o_finish_calc <= '1';
                else
                    o_finish_calc <= '0';
                end if;

                if counter = to_unsigned(max_count - 1, counter_w) then
                    counter <= (others => '0');

                    if (i_update_coeff = '1') then
                        s_select_update <= '1';
                    else
                        s_select_update <= '0';
                    end if;
                else
                    counter <= counter + to_unsigned(1, counter_w);

                    s_select_update <= '0';
                end if;
            end if;
        end if;
    end process;
    calc_input: for i in 0 to layer_input_size - 1 generate
        s_activ_funct_input(i) <= i_input(i)(activation_int_w - 1 downto -activation_fract_w);
    end generate calc_input;

    calc_hidden: for i in 0 to layer_hidden_size - 1 generate
        dut_bias_hidden: bias
            generic map (
               init_value        => bias_init_hidden(i)
            )
            port map (
               clk               => clk,
               areset            => areset,
               i_select_initial  => i_select_initial,
               i_select_update   => s_select_update,
               i_dbias           => i_adder_bias_hidden(i),
               o_bias            => s_bias_hidden(i)
            );

        dut_weighted_in_hidden: weighted_input
            generic map (
               layer_size        => layer_input_size
            )
            port map (
               clk               => clk,
               areset            => areset,
               i_input           => s_activ_funct_input,
               i_weight          => s_weight_hidden(i),
               i_bias            => s_bias_hidden(i),
               o_weighted_input  => s_weighted_in_hidden(i)
            );

        sigmoid: activation_funct
            port map (
               clk                 => clk,
               areset              => areset,
               i_weighted_input    => s_weighted_in_hidden(i),
               o_activation_funct  => s_activ_funct_hidden(i)
            );
    end generate calc_hidden;

   calc_output: for i in 0 to layer_output_size - 1 generate
        dut_bias_output: bias
            generic map (
               init_value        => bias_init_output(i)
            )
            port map (
               clk               => clk,
               areset            => areset,
               i_select_initial  => i_select_initial,
               i_select_update   => s_select_update,
               i_dbias           => i_adder_bias_output(i),
               o_bias            => s_bias_output(i)
            );

        dut_weighted_in_output: weighted_input
            generic map (
               layer_size        => layer_hidden_size
            )
            port map (
               clk               => clk,
               areset            => areset,
               i_input           => s_activ_funct_hidden,
               i_weight          => s_weight_output(i),
               i_bias            => s_bias_output(i),
               o_weighted_input  => s_weighted_in_output(i)
            );

        dut_activ_funct_output: activation_funct
            port map (
               clk                 => clk,
               areset              => areset,
               i_weighted_input    => s_weighted_in_output(i),
               o_activation_funct  => s_activ_funct_output(i)
            );
    end generate calc_output;

    calc_weight_hidden: for i in 0 to layer_hidden_size - 1 generate
        dut_j: for j in 0 to layer_input_size - 1 generate
            dut_weight_hidden: weight
                generic map (
                   init_value        => weight_init_hidden(i)(j)
                )
                port map (
                   clk               => clk,
                   areset            => areset,
                   i_select_initial  => i_select_initial,
                   i_select_update   => s_select_update,
                   i_dweight         => i_adder_weight_hidden(i)(j),
                   o_weight          => s_weight_hidden(i)(j)
                );
        end generate dut_j;
    end generate calc_weight_hidden;

    calc_weight_output: for i in 0 to layer_output_size - 1 generate
        dut_j: for j in 0 to layer_hidden_size - 1 generate
            dut_weight_output: weight
                generic map (
                   init_value        => weight_init_output(i)(j)
                )
                port map (
                   clk               => clk,
                   areset            => areset,
                   i_select_initial  => i_select_initial,
                   i_select_update   => s_select_update,
                   i_dweight         => i_adder_weight_output(i)(j),
                   o_weight          => s_weight_output(i)(j)
                );
        end generate dut_j;
    end generate calc_weight_output;

    o_weight_hidden     <= s_weight_hidden;
    o_weight_output     <= s_weight_output;
    o_activation_hidden <= s_activ_funct_hidden;
    o_activation_output <= s_activ_funct_output;
end rtl;
