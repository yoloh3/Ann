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
use STD.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.fixed_float_types.all;
use ieee.std_logic_textio.all;
use work.config_pkg.is_real_equal;

---------------------------------------------------------------------------------
-- Entity declaration
--------------------------------------------------------------------------------- 
entity bias_tb is
    generic (
        INIT_VALUE      : real    := -1.0;
        INTEGER_WIDTH   : integer := 8;
        FLOAT_WIDTH     : integer := -24
    );
end;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture bench of bias_tb is
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
    signal i_dbias:          sfixed(INTEGER_WIDTH - 1 downto FLOAT_WIDTH) := (others => '0');
    signal o_bias:           sfixed(INTEGER_WIDTH - 1 downto FLOAT_WIDTH) := (others => '0');

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
    areset <= '1' after PERIOD;

    prt_input: process (i_dbias)
        variable my_line : LINE;
    begin
        write(my_line, string'("i_dbias ="));
        write(my_line, to_real(i_dbias), right, 15);
        write(my_line, string'(", at "));
        write(my_line, now);
        writeline(output, my_line);
    end process;

    prt_output: process (o_bias)
        variable my_line : LINE;
    begin
        write(my_line, string'("o_bias  ="));
        write(my_line, to_real(o_bias), right, 15);
        write(my_line, string'(", at "));
        write(my_line, now);
        writeline(output, my_line);
        writeline(output, my_line);
    end process;

    stimulus: process
        variable v_expected: real := 0.0;
    begin
        wait until areset = '1';

        -- Main simulation
        wait until rising_edge(clk);

        i_select_initial <= '1';
        i_select_update  <= '0';
        i_dbias <= to_sfixed(2.5, i_dbias);
        v_expected := -1.0;

        wait until rising_edge(clk); 
        wait for 1 ns;
        assert is_real_equal(to_real(o_bias), v_expected, -6.0)
            report "Test 1 failed!";


        i_select_initial <= '1';
        i_select_update  <= '1';
        i_dbias <= to_sfixed(3.2, i_dbias);
        v_expected := -1.0;

        wait until rising_edge(clk); 
        wait for 1 ns;
        assert is_real_equal(to_real(o_bias), v_expected, -6.0)
            report "Test 2 failed!";


        i_select_initial <= '0';
        i_select_update  <= '0';
        i_dbias <= to_sfixed(7.5, i_dbias);
        v_expected := 0.0;

        wait until rising_edge(clk); 
        wait for 1 ns;
        assert is_real_equal(to_real(o_bias), v_expected, -6.0)
            report "Test 3 failed!";

        i_select_initial <= '0';
        i_select_update  <= '1';
        i_dbias <= to_sfixed(2.6, i_dbias);
        v_expected := 2.6;

        wait until rising_edge(clk); 
        wait for 1 ns;
        assert is_real_equal(to_real(o_bias), v_expected, -6.0)
            report "Test 4 failed!";

        -- UPDATE: Convert from compare fixed_point to cal error with bias
        i_select_initial <= '0';
        i_select_update  <= '1';
        i_dbias <= to_sfixed(2.6, i_dbias);
        v_expected := 5.2;

        wait until rising_edge(clk); 
        wait for 10 ns;
        assert is_real_equal(to_real(o_bias), v_expected, -6.0)
            report "Test 5 failed!";
        wait;
    end process;
end;
