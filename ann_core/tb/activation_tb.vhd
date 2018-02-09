---------------------------------------------------------------------------------
-- -- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.  -- The University of Engineering and Technology, Vietnam National University.  -- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : activation_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Jan 18 2018       @Modified Date : Jan 18 2018 15:29
-- @Project         : Artificial Neural Network
-- @Module          : activation_tb
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
use std.env.all;

use ieee.math_real.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;
use work.tb_pkg.all;

entity activation_tb is
end entity activation_tb;

architecture tb of activation_tb is
    signal clk                  : std_logic                 := '0';
    signal areset               : std_logic                 := '1';
    signal i_weighted_input     : weighted_input_float_t;
    signal o_activation_funct   : activation_float_t;
    signal mse_error            : real;

    constant CLOCK_CYCLE : time := 20 ns;

    component activation_funct is
        port (
            clk                 : in    std_logic;
            areset              : in    std_logic;
            i_weighted_input    : in    weighted_input_float_t;
            o_activation_funct  : out   activation_float_t 
             );
    end component;

begin
    DUT : activation_funct 
        port map (
            clk                     => clk,
            areset                  => areset,
            i_weighted_input        => i_weighted_input,
            o_activation_funct      => o_activation_funct
        );

    clk <= not clk after CLOCK_CYCLE / 2;
    areset <= '0' after 3 * CLOCK_CYCLE;

    simulate : process

        procedure test_activ_funct( 
            constant in_real:   in real)
        is
            variable expected:  real;
            variable actual:  real;
        begin
            i_weighted_input <= to_sfixed(in_real, i_weighted_input);
            expected := 1.0 / (1.0 + exp(-in_real));
            wait until rising_edge(clk);
            wait for CLOCK_CYCLE / 8; 

            actual := to_real(o_activation_funct);
            -- print(real'image(expected) & string'(" ") & real'image(actual));
            mse_error <= mse_error 
                       + mse(expected, actual);
		end procedure test_activ_funct;
    begin
		wait until areset = '0';
		i_weighted_input <= (others => '0');
		mse_error <= 0.0;
		wait for CLOCK_CYCLE;

		for i in 0 to 255 loop
			test_activ_funct(8.0 - real(i) / 16.0);
		end loop;

		wait for CLOCK_CYCLE;
		print(string'("MSE = ") & real'image(mse_error / 2.0**8));
		finish(1);
	 end process simulate;
end tb;
