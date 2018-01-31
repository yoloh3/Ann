----------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : backward.vhd
-- @Author          : Dung-Van Nguyen
-- @Modifier        : Huy-Hung Ho
-- @Created Date    : Tue 21 Nov 2017 11:00:06 PM DST   
-- @Modified Date   : Jan 31 2018 12:31
-- @Project         : Neural Network
-- @Module          : backward
-- @Description     : Description of module.
-- @Version         : 0.1beta
-- @ID              : N/A
--
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;

entity backward is
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
end entity;

architecture struct of backward is
    component derivative_activation
        port (
            clk                    : in  std_logic;
            areset                 : in  std_logic;
            i_a                    : in  activation_float_t;
            o_dadz                 : out dadz_float_t
        );
    end component;
    component error_hidden
        port (
            clk                  : in  std_logic;
            areset               : in  std_logic;
            i_dadz2              : in  dadz_float_t;
            i_weight_ouput_array : in  weight_array_t(layer_output_size - 1 downto 0);
            i_error_ouput_array  : in  error_array_t(layer_output_size - 1 downto 0);
            o_error_hidden       : out error_float_t
        );
    end component;
    component error_ouput
        port (
            clk                : in  std_logic;
            areset             : in  std_logic;
            i_activation_ouput : in  activation_float_t;
            i_exptected_value  : in  input_float_t;
            i_dadz_ouput       : in  dadz_float_t;
            o_error_ouput      : out error_float_t
        );
    end component;
    component delta_weight is
        port (
            clk            : in  std_logic;
            areset         : in  std_logic;
            i_error        : in  error_float_t;
            i_input_signal : in  input_float_t;
            o_delta_weight : out weight_float_t
        );
    end component;
    component delta_bias is
        port (
            clk            : in  std_logic;
            areset         : in  std_logic;
            i_error        : in  error_float_t;
            o_delta_bias   : out weight_float_t
        );
    end component;
    component delta_weight_cumulation  is
        port (
            clk             : in  std_logic;
            areset          : in  std_logic;
            i_delta_weight  : in  weight_float_t;
            o_dw_cumulation : out weight_float_t
        );
    end component;
    component delta_bias_cumulation  is
        port (
            clk               : in  std_logic;
            areset            : in  std_logic;
            i_delta_bias      : in  bias_float_t;
            o_bias_cumulation : out bias_float_t
        );
    end component;

    signal s_tmp_input                : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp2_input               : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp3_input               : input_array_t(layer_input_size - 1 downto 0);
    signal s_tmp_expected             : input_array_t(layer_input_size - 1 downto 0);

    signal s_tmp_activation_output    : activation_array_t(layer_output_size - 1 downto 0);

    signal s_tmp_activation_hidden    : activation_array_t(layer_hidden_size - 1 downto 0);
    signal s_tmp2_activation_hidden   : activation_array_t(layer_hidden_size - 1 downto 0);
    signal s_tmp3_activation_hidden   : activation_array_t(layer_hidden_size - 1 downto 0);

    signal s_weight_output  : weight_array2_output2hidden_t;
    signal s_weight_output_2 : weight_array2_output2hidden_t;

    signal s_error_output             : error_array_t(layer_output_size - 1 downto 0);
    signal s_tmp_error_output         : error_array_t(layer_output_size - 1 downto 0);

    signal s_error_hidden             : error_array_t(layer_hidden_size - 1 downto 0);

    signal s_dadz_output              : dadz_array_t(layer_output_size - 1 downto 0);
    signal s_dadz_hidden              : dadz_array_t(layer_hidden_size - 1 downto 0);
    signal s_tmp_dadz_hidden          : dadz_array_t(layer_hidden_size - 1 downto 0);

    signal s_delta_weight_output      : weight_array2_hidden2output_t;
    signal s_delta_weight_hidden      : weight_array2_input2hidden_t;

    signal s_delta_bias_output    : bias_array_t(layer_output_size - 1 downto 0);
    signal s_delta_bias_output_2    : bias_array_t(layer_output_size - 1 downto 0);
    signal s_delta_bias_hidden    : bias_array_t(layer_hidden_size - 1 downto 0);


begin

   -- Calculate dadz, error, delta_bias
   calc_layer_output: for i in 0 to layer_output_size - 1 generate
       DUT_derivative_activation: derivative_activation
           port map (
              clk                     => clk,
              areset                  => areset,
              i_a                     => i_activation_output(i),
              o_dadz                  => s_dadz_output(i)
           );

       DUT_error_ouput: error_ouput
           port map (
              clk                 => clk,
              areset              => areset,
              i_activation_ouput  => s_tmp_activation_output(i),
              i_exptected_value   => s_tmp_expected(i),
              i_dadz_ouput        => s_dadz_output(i),
              o_error_ouput       => s_error_output(i)
           );

       DUT_delta_bias: delta_bias
           port map (
              clk             => clk,
              areset          => areset,
              i_error         => s_error_output(i),
              o_delta_bias    => s_delta_bias_output(i)
           );
   end generate;

   convert_matrix_weight: for i in 0 to layer_hidden_size - 1 generate
       w_j: for j in 0 to layer_output_size - 1 generate
            s_weight_output(i)(j) <= i_weight_output(j)(i);
        end generate w_j;
    end generate convert_matrix_weight;

   -- calc dadz, error, delta bias
   calc_layer_hidden: for i in 0 to layer_hidden_size - 1 generate
       DUT_derivative_activation: derivative_activation
           port map (
              clk                     => clk,
              areset                  => areset,
              i_a                     => i_activation_hidden(i),
              o_dadz                  => s_dadz_hidden(i)
           );

       DUT_error_hidden: error_hidden
           port map (
              clk                   => clk,
              areset                => areset,
              i_dadz2               => s_tmp_dadz_hidden(i),
              i_weight_ouput_array  => s_weight_output_2(i),
              i_error_ouput_array   => s_error_output,
              o_error_hidden        => s_error_hidden(i)
           );

       DUT_delta_bias: delta_bias
           port map (
              clk             => clk,
              areset          => areset,
              i_error         => s_error_hidden(i),
              o_delta_bias    => s_delta_bias_hidden(i)
           );
   end generate;

   calc_dw_output_i: for i in 0 to layer_hidden_size - 1 generate
       dw_j: for j in 0 to layer_output_size - 1 generate
           DUT_delta_weight: delta_weight
               port map (
                  clk             => clk,
                  areset          => areset,
                  i_error         => s_tmp_error_output(j),
                  i_input_signal  => s_tmp3_activation_hidden(i),
                  o_delta_weight  => s_delta_weight_output(j)(i)
               );
       end generate dw_j;
   end generate calc_dw_output_i;

   calc_dw_hidden_i: for i in 0 to layer_input_size - 1 generate
       dw_j: for j in 0 to layer_hidden_size - 1 generate
           DUT_delta_weight: delta_weight
               port map (
                  clk             => clk,
                  areset          => areset,
                  i_error         => s_error_hidden(j),
                  i_input_signal  => s_tmp3_input(i),
                  o_delta_weight  => s_delta_weight_hidden(j)(i)
               );
       end generate dw_j;
   end generate calc_dw_hidden_i;

   delay: process(clk)
   begin
       if(areset  = '1') then
               s_tmp_activation_output     <= (others => (others => '0'));
               s_tmp_expected              <= (others => (others => '0'));
               s_tmp_dadz_hidden           <= (others => (others => '0'));

               s_weight_output_2           <= (others => (others => (others => '0')));

               s_tmp_activation_hidden     <= (others => (others => '0'));
               s_tmp2_activation_hidden    <= (others => (others => '0'));
               s_tmp3_activation_hidden    <= (others => (others => '0'));

               s_tmp_error_output          <= (others => (others => '0'));
               s_delta_bias_output_2       <= (others => (others => '0'));

               s_tmp_input                 <= (others => (others => '0'));
               s_tmp2_input                <= (others => (others => '0'));
               s_tmp3_input                <= (others => (others => '0'));
       elsif(rising_edge(clk)) then
           s_tmp_activation_output     <= i_activation_output;
           s_tmp_expected              <= i_expected;
           s_tmp_dadz_hidden           <= s_dadz_hidden;

           s_weight_output_2           <= s_weight_output;

           s_tmp_activation_hidden     <= i_activation_hidden;
           s_tmp2_activation_hidden    <= s_tmp_activation_hidden;
           s_tmp3_activation_hidden    <= s_tmp2_activation_hidden;

           s_tmp_error_output          <= s_error_output;
           s_delta_bias_output_2       <= s_delta_bias_output;

           s_tmp_input                 <= i_input;
           s_tmp2_input                <= s_tmp_input;
           s_tmp3_input                <= s_tmp2_input;
       end if;
   end process;

   calc_dw_adder_output_i: for i in 0 to layer_hidden_size - 1 generate
       adder_j: for j in 0 to layer_output_size - 1 generate
           DUT_delta_weight_cumulation: delta_weight_cumulation
               port map (
                  clk                       => clk,
                  areset                    => areset ,
                  i_delta_weight            => s_delta_weight_output(j)(i),
                  o_dw_cumulation           => o_adder_weight_output(j)(i)
               );
       end generate adder_j;
   end generate calc_dw_adder_output_i;

   calc_dw_adder_hidden_i: for i in 0 to layer_input_size - 1 generate
       adder_j: for j in 0 to layer_hidden_size - 1 generate
           DUT_delta_weight_cumulation: delta_weight_cumulation
               port map (
                  clk                       => clk,
                  areset                    => areset,
                  i_delta_weight            => s_delta_weight_hidden(j)(i),
                  o_dw_cumulation           => o_adder_weight_hidden(j)(i)
               );
       end generate adder_j;
   end generate calc_dw_adder_hidden_i;

   calc_db_adder_output: for i in 0 to layer_output_size - 1 generate
       DUT_delta_bias_cumulation: delta_bias_cumulation
           port map (
              clk                     => clk,
              areset                  => areset,
              i_delta_bias            => s_delta_bias_output_2(i),
              o_bias_cumulation       => o_adder_bias_output(i)
           );
   end generate calc_db_adder_output;

  calc_db_adder_hidden: for i in 0 to layer_hidden_size - 1 generate
       DUT_delta_bias_cumulation: delta_bias_cumulation
           port map (
              clk                     => clk,
              areset                  => areset,
              i_delta_bias            => s_delta_bias_hidden(i),
              o_bias_cumulation       => o_adder_bias_hidden(i)
           );
  end generate calc_db_adder_hidden;
end struct;
