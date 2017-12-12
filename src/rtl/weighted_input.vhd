---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : weighted_input.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier      : Huy-Hung Ho
-- @Created Date    : 9 Nov 2017        @Modified Date : xim 30 2017 09:00
-- @Project         : Neural Network
-- @Module          : NN_weighted_input
-- @Description     : Calculation of 2 input (a2_1,a2_2) and 1 output (z2)
-- Input:
--  ki      : 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 sfixed    : input data (i=1,2)
--  b2      : 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 sfixed    : bias value
--  w2_i        : 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 sfixed    : weight value (i=1,2)
--  clk     : 1 bit
--  reset       : 1 bit : high active
-- Output:
--  weighted_input      : 8 bits 0000.0000 : output value
-- Latency: 1 clk
-- @Version         : 0.1beta
-- @ID              : N/A
--
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;

---------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------
entity weighted_input is
    generic (layer_size  : integer := 2);
    port (
        clk              : in  std_logic;
        reset            : in  std_logic;
        i_input          : in  activation_array_t(layer_size - 1 downto 0);
        i_weight         : in  weight_array_t(layer_size - 1 downto 0);
        i_bias           : in  bias_float_t;
        o_weighted_input : out weighted_input_float_t
    );
end weighted_input;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture rtl of weighted_input is
    constant mult_int_w   : integer := input_int_w + weight_int_w;
    constant mult_fract_w : integer := input_fract_w + weight_fract_w;
    type mult_array_t is array (integer range <>)
        of sfixed(mult_int_w -1 downto -mult_fract_w);

    signal s_mult_array   : mult_array_t(layer_size - 1 downto 0);

    --add more 1 bit of sum
    signal tmp_sum        : sfixed(bias_int_w downto -bias_fract_w);
    signal saturation     : std_logic;

    constant max_output     : weighted_input_float_t := '1' &
    (weighted_input_int_w - 2 downto -weighted_input_fract_w => '0');
    constant near_max_output: weighted_input_float_t := '0' &
    (weighted_input_int_w - 2 downto -weighted_input_fract_w => '1');
begin

    mult_parallel: for i in 0 to layer_size - 1 generate
        s_mult_array(i) <= i_input(i) * i_weight(i);
    end generate mult_parallel;

    weighted: process(clk)
        variable v_sum_mult : sfixed(bias_int_w downto -bias_fract_w);
    begin
        if rising_edge(clk) then
            if(reset  = '1') then
                v_sum_mult := (others => '0');
                tmp_sum    <= (others => '0');
            else 
                v_sum_mult := to_sfixed(0.0, v_sum_mult); 
                for i in 0 to layer_size - 1 loop
                    v_sum_mult := v_sum_mult(bias_int_w - 1 downto -bias_fract_w)
                                + s_mult_array(i)(bias_int_w - 1 downto -bias_fract_w);
                end loop;
                    tmp_sum <= v_sum_mult(bias_int_w - 1 downto -bias_fract_w)
                             + i_bias;
            end if;
        end if;
    end process;

    saturation <= (not(and(tmp_sum(bias_int_w downto weighted_input_int_w - 1)))) and
                  (or(tmp_sum(bias_int_w downto weighted_input_int_w - 1)));

    o_weighted_input <= tmp_sum(weighted_input_int_w - 1 downto
                        -weighted_input_fract_w) when saturation = '0' else
                        max_output when tmp_sum(weight_int_w - 1) = '1' else
                        near_max_output;
end rtl;
