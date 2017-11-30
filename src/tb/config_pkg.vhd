---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : config_pkg.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : xim 23 2017       @Modified Date : xim 23 2017 11:29
-- @Project         : Artificial Neural Network
-- @Module          : config_pkg
-- @Description     : Some cofiguration for vhdl src
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.fixed_pkg.ALL;

use STD.textio.all;

---------------------------------------------------------------------------------
-- Package declaration
--------------------------------------------------------------------------------- 
package config_pkg IS
    constant INTEGER_WIDTH   : integer := 8;
    constant FLOAT_WIDTH     : integer := -24;

    subtype nn_float_t is sfixed(INTEGER_WIDTH-1 downto FLOAT_WIDTH);

    function is_real_equal(a, b, epsilon : real) return boolean;

    procedure print (
        constant prefix : in string);

    procedure test_case (
        signal clk         : in std_logic;
        constant initial_i : in std_logic;
        constant update_i  : in std_logic;
        constant bias_i    : in real;
        signal result      : in nn_float_t;
        constant expected  : in real;
        signal initial_o   : out std_logic;
        signal update_o    : out std_logic;
        signal i_bias_o    : out nn_float_t);
end config_pkg;

---------------------------------------------------------------------------------
-- Package description
---------------------------------------------------------------------------------
package body config_pkg IS

    function is_real_equal(a, b, epsilon : real) return boolean is
    begin
        if a = b then
            return true;
        else
            return abs(a - b) < 10.0 ** epsilon;
        end if;
    end function;

    procedure print(
        constant prefix : in string)
    is
        variable my_line : line;
    begin
        write(my_line, prefix);
        writeline(output, my_line);
    end print;

    procedure test_case (
        signal clk         : in std_logic;
        constant initial_i : in std_logic;
        constant update_i  : in std_logic;
        constant bias_i    : in real;
        signal result      : in nn_float_t;
        constant expected  : in real;
        signal initial_o   : out std_logic;
        signal update_o    : out std_logic;
        signal i_bias_o    : out nn_float_t)
    is
    begin
        initial_o <= initial_i;
        update_o  <= update_i;
        i_bias_o <= to_sfixed(bias_i, result);

        wait until rising_edge(clk);
        wait for 1ns;
        print("At: " & time'image(now) & " i_dbias = " & real'image(bias_i) & " o_bias = " & real'image(to_real(result)));
        assert is_real_equal(to_real(result), expected, -6.0)
            report "Test failed!";

    end test_case;
end config_pkg;
