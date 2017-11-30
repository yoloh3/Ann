---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : bias_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Nov 22 2017       @Modified Date : Nov 22 2017 15:59
-- @Project         : Artificial Neural Network
-- @Module          : bias_tb
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
use ieee.fixed_float_types.all;
use ieee.std_logic_textio.all;
use work.config_pkg.all;

use std.textio.all;
use std.env.all;

---------------------------------------------------------------------------------
-- Entity declaration
--------------------------------------------------------------------------------- 
entity bias_tb is

end;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture bench of bias_tb is

    constant INIT_VALUE      : real    := -1.0;

    component bias
        generic (
            INIT_VALUE      : real := -1.0;
            INTEGER_WIDTH   : integer := 8;
            FLOAT_WIDTH     : integer := -24
        );
        port(
            clk              : in  std_logic;
            areset           : in  std_logic;
            i_select_initial : in  std_logic;
            i_select_update  : in  std_logic;
            i_dbias          : in  sfixed(INTEGER_WIDTH - 1 downto FLOAT_WIDTH);
            o_bias           : out sfixed(INTEGER_WIDTH - 1 downto FLOAT_WIDTH)
        );
    end component;

    signal clk:              std_logic  := '0';
    signal areset:           std_logic  := '0';
    signal i_select_initial: std_logic  := '0';
    signal i_select_update:  std_logic  := '0';
    signal i_dbias:          nn_float_t := (others => '0');
    signal o_bias:           nn_float_t := (others => '0');

    constant PERIOD:         time := 100 ns;
begin
    uut: bias
        generic map (INIT_VALUE       => INIT_VALUE,
                     INTEGER_WIDTH    => INTEGER_WIDTH,
                     FLOAT_WIDTH      => FLOAT_WIDTH)
        port map (clk              => clk,
                  areset           => areset,
                  i_select_initial => i_select_initial,
                  i_select_update  => i_select_update,
                  i_dbias          => i_dbias,
                  o_bias           => o_bias );

    clk <= not(clk) after PERIOD / 2;
    areset <= '1' after 10*PERIOD + PERIOD / 2;

    stimulus: process
        variable v_expected: real := 0.0;
    begin
        wait until areset = '1';

        -- -- Main simulation
        -- wait until rising_edge(clk);

        test_case(clk, '1', '0', 2.5, o_bias, -1.0, i_select_initial, i_select_update, i_dbias);
        test_case(clk, '1', '1', 3.2, o_bias, -1.0, i_select_initial, i_select_update, i_dbias);
        test_case(clk, '0', '0', 7.5, o_bias, 0.0, i_select_initial, i_select_update, i_dbias);
        test_case(clk, '0', '1', 2.6, o_bias, 2.6, i_select_initial, i_select_update, i_dbias);

        -- UPDATE: Convert from compare fixed_point to cal error with bias
        test_case(clk, '0', '1', 2.6, o_bias, 5.2, i_select_initial, i_select_update, i_dbias);
        finish(2);
    end process;
end;
