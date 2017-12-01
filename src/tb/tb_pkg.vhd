---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : tb_pkg.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Nov 26 2017       @Modified Date : Nov 26 2017 20:10
-- @Project         : Artificial Neural Network
-- @Module          : tb_pkg
-- @Description     :
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
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.rtl_pkg.all;

---------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------
package tb_pkg is
    function is_real_equal(a, b, error_rate: real) return boolean;

    procedure print (
        constant prefix : in string);

    procedure test_case_backward (
        signal   clk            : in  std_logic;
        constant i_input1       : in  real;
        constant i_input2       : in  real;
        constant i_expected1    : in  real;
        constant i_expected2    : in  real;
        constant i_weight_out11 : in real;
        constant i_weight_out12 : in real;
        constant i_weight_out21 : in real;
        constant i_weight_out22 : in real;
        constant i_weight_out31 : in real;
        constant i_weight_out32 : in real;
        constant i_acti_out1    : in real;
        constant i_acti_out2    : in real;
        constant i_acti_hid1    : in real;
        constant i_acti_hid2    : in real;
        constant i_acti_hid3    : in real;
        --signal result : in  bias_float_t;
        signal   o_input
            : out input_array_t(layer_input_size - 1 downto 0);
        signal o_expected
            : out input_array_t(layer_input_size - 1 downto 0);
        signal o_weight_output
            : out weight_array2_hidden2output_t;
        signal o_acti_out
            : out activation_array_t(layer_output_size - 1 downto 0);
        signal o_acti_hid
            : out activation_array_t(layer_hidden_size - 1 downto 0));

     procedure test_case_bias (
        signal clk         : in  std_logic;
        constant i_initial : in  std_logic;
        constant i_update  : in  std_logic;
        constant i_bias    : in  real;
        signal result      : in  bias_float_t;
        constant expected  : in  real;
        signal o_initial   : out std_logic;
        signal o_update    : out std_logic;
        signal o_bias      : out bias_float_t);

   procedure test_case_der_activ (
        signal clk         : in  std_logic;
        constant i_input   : in  real;
        signal result      : in  dadz_float_t;
        constant expected  : in  real;
        signal o_input     : out activation_float_t);
end tb_pkg;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
package body tb_pkg is
    function is_real_equal(a, b, error_rate: real) return boolean is
    begin
        if a = b then
            return true;
        else
            return abs(a - b) < 10.0 ** error_rate;
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

    procedure test_case_backward (
        signal   clk            : in  std_logic;
        constant i_input1       : in  real;
        constant i_input2       : in  real;
        constant i_expected1    : in  real;
        constant i_expected2    : in  real;
        constant i_weight_out11 : in  real;
        constant i_weight_out12 : in  real;
        constant i_weight_out21 : in  real;
        constant i_weight_out22 : in  real;
        constant i_weight_out31 : in  real;
        constant i_weight_out32 : in  real;
        constant i_acti_out1    : in  real;
        constant i_acti_out2    : in  real;
        constant i_acti_hid1    : in  real;
        constant i_acti_hid2    : in  real;
        constant i_acti_hid3    : in  real;
        --signal result : in  bias_float_t;
        signal o_input         : out input_array_t(layer_input_size - 1 downto 0);
        signal o_expected      : out input_array_t(layer_input_size - 1 downto 0);
        signal o_weight_output : out weight_array2_hidden2output_t;
        signal o_acti_out      : out activation_array_t(layer_output_size - 1 downto 0);
        signal o_acti_hid      : out activation_array_t(layer_hidden_size - 1 downto 0))
    is 
    begin
        o_input(0)             <= to_sfixed(i_input1, input_int_w-1, -input_fract_w);
        o_input(1)             <= to_sfixed(i_input2, input_int_w-1, -input_fract_w);
        o_expected(0)          <= to_sfixed(i_expected1, input_int_w-1, -input_fract_w);
        o_expected(1)          <= to_sfixed(i_expected2, input_int_w-1, -input_fract_w);
        o_weight_output(0)(0)  <= to_sfixed(i_weight_out11, weight_int_w-1, -weight_fract_w);
        o_weight_output(0)(1)  <= to_sfixed(i_weight_out12, weight_int_w-1, -weight_fract_w);
        o_weight_output(1)(0)  <= to_sfixed(i_weight_out21, weight_int_w-1, -weight_fract_w);
        o_weight_output(1)(1)  <= to_sfixed(i_weight_out22, weight_int_w-1, -weight_fract_w);
        o_weight_output(2)(0)  <= to_sfixed(i_weight_out31, weight_int_w-1, -weight_fract_w);
        o_weight_output(2)(1)  <= to_sfixed(i_weight_out32, weight_int_w-1, -weight_fract_w);
        o_acti_out(0)          <= to_sfixed(i_acti_out1, activation_int_w-1, -activation_fract_w);
        o_acti_out(1)          <= to_sfixed(i_acti_out2, activation_int_w-1, -activation_fract_w);
        o_acti_hid(0)          <= to_sfixed(i_acti_hid1, activation_int_w-1, -activation_fract_w);
        o_acti_hid(1)          <= to_sfixed(i_acti_hid2, activation_int_w-1, -activation_fract_w);
        o_acti_hid(2)          <= to_sfixed(i_acti_hid3, activation_int_w-1, -activation_fract_w);

        wait until rising_edge(clk);
        wait for 1 ns;
        print("At: " & time'image(now) & " i_input1 = " & real'image(i_input1) &
        " i_input2 = " & real'image(i_input2));
        --assert is_real_equal(to_real(result), expected, -6.0)
        --    report "Test failed!";
    end test_case_backward;

    procedure test_case_bias (
        signal clk         : in std_logic;
        constant i_initial : in std_logic;
        constant i_update  : in std_logic;
        constant i_bias    : in real;
        signal result      : in bias_float_t;
        constant expected  : in real;
        signal o_initial   : out std_logic;
        signal o_update    : out std_logic;
        signal o_bias      : out bias_float_t)
    is
    begin
        o_initial <= i_initial;
        o_update  <= i_update;
        o_bias    <= to_sfixed(i_bias, result);

        wait until rising_edge(clk);
        wait for 1 ns;
        print("At: " & time'image(now) & " i_dbias = " & real'image(i_bias) & " o_bias = " & real'image(to_real(result)));
        assert is_real_equal(to_real(result), expected, -6.0)
            report "Test failed!";
    end test_case_bias;

    procedure test_case_der_activ (
        signal clk         : in  std_logic;
        constant i_input   : in  real;
        signal result      : in  dadz_float_t;
        constant expected  : in  real;
        signal o_input     : out activation_float_t)
    is
    begin
        o_input <= to_sfixed(i_input, activation_int_w - 1, -activation_fract_w);

        wait until rising_edge(clk);
        wait for 1 ns;
        print("At: " & time'image(now) & " i_input = " & real'image(i_input)
        & " o_input = " & real'image(to_real(result)));
        assert is_real_equal(to_real(result), expected, -6.0)
            report "Test failed!";
    end test_case_der_activ;
end tb_pkg;
