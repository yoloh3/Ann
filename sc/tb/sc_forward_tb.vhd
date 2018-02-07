---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : sc_forward_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Feb 05 2018       @Modified Date : Feb 05 2018 14:31
-- @Project         : Artificial Neural Network
-- @Module          : sc_forward_tb
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
library ieee;
use std.env.all;
use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sc_rtl_pkg.all;
use work.sc_tb_pkg.all;
use ieee.math_real.all;

---------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------
entity sc_forward_tb is
end entity;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of sc_forward_tb is
    -- signal declaration
    signal s_start            : std_logic := '0';
    signal s_input             : sc_array_t(0 to layer_input_size - 1)
        := (others => (others => '0'));
    signal s_weight_hidden     : sc_array2_input2hidden_t
        := (others => (others => (others => '0')));
    signal s_weight_output     : sc_array2_hidden2output_t
        := (others => (others => (others => '0')));
    signal s_bias_hidden       : sc_array_t(0 to layer_hidden_size - 1)
        := (others => (others => '0'));
    signal s_bias_output       : sc_array_t(0 to layer_output_size - 1)
        := (others => (others => '0'));

    signal s_o_finish_calc       : std_logic;
    signal s_o_activation_output : sc_array_t(0 to layer_output_size - 1);
    signal s_clk                 : std_logic := '0';
    signal s_reset               : std_logic := '0';
    signal mse_error             : real := 0.0;
    constant period              : time := 10 ns;

begin
    -- device unit test
    dut: entity work.sc_forward
    port map (
       clk                    => s_clk,
       areset                 => s_reset,
       i_start                => s_start,

       i_input                => s_input,
       i_weight_hidden        => s_weight_hidden,
       i_weight_output        => s_weight_output,
       i_bias_hidden          => s_bias_hidden,
       i_bias_output          => s_bias_output,

       o_finish_calc          => s_o_finish_calc,
       o_activation_output    => s_o_activation_output
    );

    s_clk     <= not(s_clk)   after period / 2;
    s_reset   <= '1'          after 3 * period;

    -- waveform generation
    WaveGen_proc: process
        procedure test_case (
            constant v_input         : in real_array_t(0 to layer_input_size - 1); 
            constant v_weight_hidden : in real_array21_t;
            constant v_weight_output : in real_array22_t;
            constant v_bias_hidden   : in real_array_t(0 to layer_hidden_size - 1);
            constant v_bias_output   : in real_array_t(0 to layer_output_size - 1))
        is
            variable v_a2: real_array_t(0 to layer_hidden_size - 1);
            variable v_a3: real_array_t(0 to layer_output_size - 1);
        begin
            -- Count expected result
            v_a2(0) := sigmoid_funct((v_input(0) * v_weight_hidden(0)(0)
                     + v_input(1) * v_weight_hidden(0)(1)
                     + v_bias_hidden(0)) * 10.0);
            v_a2(1) := sigmoid_funct((v_input(0) * v_weight_hidden(1)(0)
                     + v_input(1) * v_weight_hidden(1)(1)
                     + v_bias_hidden(1)) * 10.0);
            v_a2(2) := sigmoid_funct((v_input(0) * v_weight_hidden(2)(0)
                     + v_input(1) * v_weight_hidden(2)(1)
                     + v_bias_hidden(2)) * 10.0);

            v_a3(0)   := sigmoid_funct(v_a2(0) * v_weight_output(0)(0)
                       + v_a2(1)  * v_weight_output(0)(1)
                       + v_a2(2) * v_weight_output(0)(2)
                       + v_bias_output(0));

            v_a3(1)   := sigmoid_funct(v_a2(0) * v_weight_output(1)(0)
                       + v_a2(1)  * v_weight_output(1)(1)
                       + v_a2(2) * v_weight_output(1)(2)
                       + v_bias_output(1));

            for i in 0 to layer_input_size - 1 loop
                s_input(i) <= real_sign_to_stdlv(v_input(i), sc_data_width);
                for j in 0 to layer_hidden_size - 1 loop
                    s_weight_hidden(j)(i) <= real_sign_to_stdlv(v_weight_hidden(j)(i), sc_data_width);
                end loop;
                s_bias_output(i) <= real_sign_to_stdlv(v_bias_output(i), sc_data_width);
            end loop;

            for i in 0 to layer_hidden_size - 1 loop
                s_bias_hidden(i) <= real_sign_to_stdlv(v_bias_hidden(i), sc_data_width);
                for j in 0 to layer_output_size - 1 loop
                    s_weight_output(j)(i) <= real_sign_to_stdlv(v_weight_output(j)(i), sc_data_width);
                end loop;
            end loop;

            s_start <= '1';
            wait until rising_edge(s_clk);
            wait for period / 8;
            s_start <= '0';
            wait until s_o_finish_calc <= '1';
            wait until rising_edge(s_clk);

            -- print("Expected a2:");
            -- for i in 0 to layer_hidden_size - 1 loop
                -- print(real'image(v_a2(i)) & string'(" "));
            -- end loop;
            -- print("");

            print("Expected a3 vs actual a3: ");
            for i in 0 to layer_output_size - 1 loop
                print(real'image(v_a3(i)) & string'(" ")
                    & real'image(stdlv_sign_to_real(s_o_activation_output(i))));

                mse_error <= mse_error + mse(v_a3(i),
                             stdlv_sign_to_real(s_o_activation_output(i)));
            end loop;
            print("");
        end procedure test_case;

        variable test_num      : integer := 5;
        constant rand_num      : integer := 19;
        variable seed1, seed2  : positive;
        variable rand          : real_array_t(0 to rand_num - 1);
    begin
        s_start <= '0';
        mse_error <= 0.0;
        wait until s_reset  = '1';

        -- -- Main simulation
        print("-------  Trainning number 0 -----");

        test_case( (0.8, 0.8),
                   ((0.1, 0.4), (0.3, 0.5), (0.6, 0.1)),
                   ((0.7, 0.2, 0.9), (0.2, 0.5, 0.9)),
                   (-0.1, -0.1, -0.1), (-0.9999, -0.9999) );
 
        for i in 0 to test_num - 1 loop
            print("-------  Trainning number " & integer'image(i+1) & " -----");
            for j in 0 to rand_num - 1 loop
                uniform(seed1, seed2, rand(j));  -- random value in range 0.0 to 1.0
                rand(j) := rand(j) * 2.0 - 1.0;  -- convert -1.0 to 1.0
            end loop;

            test_case( (rand(0 to 1)),
                   ((rand(2 to 3)), (rand(4 to 5)), (rand(6 to 7))),
                   ((rand(8 to 10)), (rand(11 to 13))),
                   (rand(14 to 16)), (rand(17 to 18)) );
           wait for period;
       end loop;

        WAIT FOR 3 * period;
        print(string'("mse = ")
              & real'image(mse_error / (real(layer_output_size) * real(test_num))));

       finish(2);
   end process;
end bench;
