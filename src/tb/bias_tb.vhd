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
-- @Description     : Test bias with some input
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;
use work.tb_pkg.all;

---------------------------------------------------------------------------------
-- entity declaration
--------------------------------------------------------------------------------- 
entity bias_tb is
end;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of bias_tb is
    component bias is
        generic (
            init_value      : real    := -1.0
        );
        port(
            clk              : in  std_logic;
            areset           : in  std_logic;
            i_select_initial : in  std_logic;
            i_select_update  : in  std_logic;
            i_dbias          : in  bias_float_t;
            o_bias           : out bias_float_t
        );
    end component;

    constant init_value     : real       := -1.0;
    signal clk              : std_logic  := '0';
    signal areset           : std_logic  := '1';
    signal i_select_initial : std_logic  := '0';
    signal i_select_update  : std_logic  := '0';
    signal i_dbias          : bias_float_t := (others => '0');
    signal o_bias           : bias_float_t := (others => '0');

    constant period:         time := 100 ns;
begin
    dut: bias
        generic map (init_value     => init_value)
        port map (clk               => clk,
                  areset            => areset,
                  i_select_initial  => i_select_initial,
                  i_select_update   => i_select_update,
                  i_dbias           => i_dbias,
                  o_bias            => o_bias );

    clk <= not(clk) after period / 2;
    areset <= '0'   after period;

     stimulus: process
    begin
        wait until areset = '0';

        -- -- Main simulation
        -- wait until rising_edge(clk);

        test_case_bias(clk, '1', '0', 2.5, o_bias, -1.0, i_select_initial, i_select_update, i_dbias);
        test_case_bias(clk, '1', '1', 3.2, o_bias, -1.0, i_select_initial, i_select_update, i_dbias);
        test_case_bias(clk, '0', '0', 7.5, o_bias,  0.0, i_select_initial, i_select_update, i_dbias);
        test_case_bias(clk, '0', '1', 2.6, o_bias,  2.6, i_select_initial, i_select_update, i_dbias);

        -- UPDATE: Convert from compare fixed_point to cal error with bias
        test_case_bias(clk, '0', '1', 2.6, o_bias, 5.2, i_select_initial, i_select_update, i_dbias);
        --finish(2);
    end process;
end;
