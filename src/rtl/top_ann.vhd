---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification -- No part may be reproduced except as authorized by written permission.  -- 
-- @File            : top_ann.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : kax 05 2017       @Modified Date : Dec 11 2017 15:00
-- @Project         : Artificial Neural Network
-- @Module          : top_ann
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
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;
use ieee.math_real.all;

---------------------------------------------------------------------------------
-- Entity declaration
--------------------------------------------------------------------------------- 
entity top_ann is
    port(
        clk              : in std_logic;
        reset            : in std_logic;
        i_select_initial : in std_logic;
        i_update_coeff   : in std_logic;
        i_input          : in  input_array_t(layer_input_size - 1 downto 0);
        i_expected       : in  input_array_t(layer_input_size - 1 downto 0);
 
        o_finish_update  : out  std_logic;
        o_output_result  : out activation_array_t(layer_output_size - 1 downto 0)
    );
end entity; 

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture behavior of top_ann is
    component forward
        port (
            clk                   : in  std_logic;
            reset                 : in  std_logic;
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
    end component forward;
    component backward
        port (
            clk                   : in  std_logic;
            reset                 : in  std_logic;
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

    signal s_adder_weight_hidden :  weight_array2_input2hidden_t;
    signal s_adder_weight_output :  weight_array2_hidden2output_t;
    signal s_adder_bias_hidden   :  bias_array_t(layer_hidden_size - 1 downto 0);
    signal s_adder_bias_output   :  bias_array_t(layer_output_size - 1 downto 0);
    signal s_finish_calc         :  std_logic;
    signal s_weight_hidden       :  weight_array2_input2hidden_t;
    signal s_weight_output       :  weight_array2_hidden2output_t;
    signal s_activation_hidden   :  activation_array_t(layer_hidden_size - 1 downto 0);
    signal s_activation_output   :  activation_array_t(layer_output_size - 1 downto 0);

    signal s_tmp_input              : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp2_input             : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp3_input             : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp4_input             : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp_expected           : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp2_expected          : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp3_expected          : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp4_expected          : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp_activation_hidden  : activation_array_t(layer_hidden_size - 1 downto 0);
    signal s_tmp2_activation_hidden : activation_array_t(layer_hidden_size - 1 downto 0);

    -- Real signal for simulation
    -- signal real_adder_weight_hidden :  weight_init_input2hidden_array_t;
    -- signal real_adder_weight_output :  weight_init_hidden2output_array_t;
    -- signal real_adder_bias_hidden   :  bias_init_array_t(layer_hidden_size - 1 downto 0);
    -- signal real_adder_bias_output   :  bias_init_array_t(layer_output_size - 1 downto 0);
    -- signal real_weight_hidden       :  weight_init_input2hidden_array_t;
    -- signal real_weight_output       :  weight_init_hidden2output_array_t;
    -- signal real_activation_hidden   :  bias_init_array_t(layer_hidden_size - 1 downto 0);
    -- signal real_activation_output   :  bias_init_array_t(layer_output_size - 1 downto 0);

    signal count_epochs : integer := 0;
begin
    -- -- For simulation
    -- mult_real_w_hidden: for i in 0 to layer_hidden_size - 1 generate
        -- for_j: for j in 0 to layer_input_size - 1 generate
            -- real_adder_weight_hidden(i)(j) <= 1024.0 * to_real(s_adder_weight_hidden(i)(j));
            -- real_weight_hidden(i)(j) <= 1024.0 * to_real(s_weight_hidden(i)(j));
        -- end generate for_j;
    -- end generate mult_real_w_hidden;

    -- mult_real_w_output: for i in 0 to layer_output_size - 1 generate
        -- for_j: for j in 0 to layer_hidden_size - 1 generate
            -- real_adder_weight_output(i)(j) <= 1024.0 * to_real(s_adder_weight_output(i)(j));
            -- real_weight_output(i)(j) <= 1024.0 * to_real(s_weight_output(i)(j));
        -- end generate for_j;
    -- end generate mult_real_w_output;

    -- mult_real_hidden: for i in 0 to layer_hidden_size - 1 generate
        -- real_adder_bias_hidden(i) <= 1024.0 * to_real(s_adder_bias_hidden(i));
        -- real_activation_hidden(i) <= 1024.0 * to_real(s_activation_hidden(i));
    -- end generate mult_real_hidden;

    -- mult_real_output: for i in 0 to layer_output_size - 1 generate
        -- real_adder_bias_output(i) <= 1024.0 * to_real(s_adder_bias_output(i));
        -- real_activation_output(i) <= 1024.0 * to_real(s_activation_output(i));
    -- end generate  mult_real_output;

    dut_fw: forward
    port map (
       clk                    => clk,
       reset                  => reset ,
       i_select_initial       => i_select_initial,
       i_update_coeff         => i_update_coeff,
       i_input                => i_input,
       i_adder_weight_hidden  => s_adder_weight_hidden,
       i_adder_weight_output  => s_adder_weight_output,
       i_adder_bias_hidden    => s_adder_bias_hidden,
       i_adder_bias_output    => s_adder_bias_output,
       o_finish_calc          => s_finish_calc,
       o_weight_hidden        => s_weight_hidden,
       o_weight_output        => s_weight_output,
       o_activation_hidden    => s_activation_hidden,
       o_activation_output    => s_activation_output   
    );

    delay: process(reset , clk)
    begin
        if rising_edge(clk) then
            if (reset  = '1') then
                s_tmp_input <= (others => (others => '0'));
                s_tmp2_input <= (others => (others => '0'));
                s_tmp3_input <= (others => (others => '0'));
                s_tmp4_input <= (others => (others => '0'));

                s_tmp_expected <= (others => (others => '0'));
                s_tmp2_expected <= (others => (others => '0'));
                s_tmp3_expected <= (others => (others => '0'));
                s_tmp4_expected <= (others => (others => '0'));

                s_tmp_activation_hidden <= (others => (others => '0'));
                s_tmp2_activation_hidden <= (others => (others => '0'));
            else
                s_tmp_input <= i_input;
                s_tmp2_input <= s_tmp_input;
                s_tmp3_input <= s_tmp2_input;
                s_tmp4_input <= s_tmp3_input;

                s_tmp_expected <= i_expected;
                s_tmp2_expected <= s_tmp_expected;
                s_tmp3_expected <= s_tmp2_expected;
                s_tmp4_expected <= s_tmp3_expected;

                s_tmp_activation_hidden <= s_activation_hidden;
                s_tmp2_activation_hidden <= s_tmp_activation_hidden;
            end if;
        end if;
    end process;
     dut_bw: backward
    port map (
       clk                    => clk,
       reset                  => reset ,
       i_input                => s_tmp4_input,
       i_expected             => s_tmp4_expected,
       i_weight_output        => s_weight_output,
       i_activation_output    => s_activation_output,
       i_activation_hidden    => s_tmp2_activation_hidden,
       o_adder_weight_output  => s_adder_weight_output,
       o_adder_weight_hidden  => s_adder_weight_hidden,
       o_adder_bias_output    => s_adder_bias_output,
       o_adder_bias_hidden    => s_adder_bias_hidden   
    );

    o_output_result <= s_activation_output;

<<<<<<< HEAD
    cout_finish: process(reset, clk)
    begin
        if rising_edge(clk) then
            if (reset  = '1') then
                count_epochs <= 0;
            else
                if s_finish_calc = '1' then
                    count_epochs <= count_epochs + 1;
                end if;
=======
    cout_finish: process(areset, clk)
    begin
        if (areset = '1') then
            count <= 0;
        elsif rising_edge(clk) then
            if i_update_coeff = '1' then
                count <= count + 1;
>>>>>>> Resolves: Return to first demo version and fix bug. (demo ver: commit: 98afebf9422) (not revert).
            end if;
        end if;
    end process;

    o_finish_update <= '1' when count_epochs = epochs
                  else '0';
end behavior;
