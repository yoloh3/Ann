----------------------------------------------------------------------------------
--
-- Copyright (c) 2018 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : delta_bias_cumulation.vhd
-- @Author          : Dung-Van Nguyen
-- @Modifier        : Huy-Hung Ho
-- @Created Date    : Thu 16 Nov 2017 11:55:25 AM DST
-- @Modified Date   : Nov 27 2017 06:19
-- @Project         : Neural Network
-- @Module          : delta_bias_cumulation
-- @Description     : Description of module.
-- @Version         : 0.1blearning_rate
-- @ID              : N/A
--
---------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;

entity delta_bias_cumulation  is
    port (
        clk               : in  std_logic;
        areset            : in  std_logic;
        i_delta_bias      : in  bias_float_t;
        o_bias_cumulation : out bias_float_t
    );
end entity;

architecture rtl of delta_bias_cumulation  is
    signal s_delta_bias : bias_array_t(3 downto 0);

    constant learning_rate : bias_float_t
        := to_sfixed(learning_rate, bias_int_w - 1, -bias_fract_w);
    signal tmp_ouput
        : sfixed(2*bias_int_w + 2 downto -2*bias_fract_w);
begin
    mux4: process(clk, areset)
    begin
        if areset = '1' then
            s_delta_bias <= (others => (others => '0'));
            tmp_ouput    <= (others => '0');
        elsif rising_edge(clk) then
            s_delta_bias(3) <= s_delta_bias(2);
            s_delta_bias(2) <= s_delta_bias(1);
            s_delta_bias(1) <= s_delta_bias(0);
            s_delta_bias(0) <= i_delta_bias;
            tmp_ouput <= learning_rate
                       * (s_delta_bias(3)
                        + (s_delta_bias(2) + s_delta_bias(1))
                        + (s_delta_bias(0) + i_delta_bias));
        end if;
    end process mux4;

    o_bias_cumulation <= tmp_ouput(bias_int_w- 1 downto -bias_fract_w);
end rtl;
