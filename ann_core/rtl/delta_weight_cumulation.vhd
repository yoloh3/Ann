---------------------------------------------------------------------------------
--
-- Copyright (c) 2018 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : delta_weight_cumulation.vhd
-- @Author          : Dung-Van Nguyen
-- @Modifier        : Huy-Hung Ho
-- @Created Date    : Thu 16 Nov 2017 04:01:14 PM DST
-- @Modified Date   : xim 30 2017 09:49
-- @Project         : Neural Network
-- @Module          : delta_weight_cumulation
-- @Description     : Description of module.
-- @Version         : 0.1blearning_rate
-- @ID              : N/A
--
--------------------------------------------------------------------------------- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.numeric_std.all;
use work.rtl_pkg.all;

entity delta_weight_cumulation  is
    port (
        clk             : in  std_logic;
        areset          : in  std_logic;
        i_delta_weight  : in  weight_float_t;
        o_dw_cumulation : out weight_float_t
    );
end entity;

architecture rtl of delta_weight_cumulation  is

    signal s_delta_weight: weight_array_t(2 downto 0);

    constant learning_rate : weight_float_t
        := to_sfixed(learning_rate, weight_int_w - 1, -weight_fract_w);
    signal tmp_output
        : sfixed(2*weight_int_w + 1 downto -2*weight_fract_w);
begin
    mux4: process(clk, areset)
    begin
        if areset = '1' then
            s_delta_weight <= (others => (others => '0'));
            tmp_output      <= (others => '0');
        elsif rising_edge(clk) then
            s_delta_weight(2) <= s_delta_weight(1);
            s_delta_weight(1) <= s_delta_weight(0);
            s_delta_weight(0) <= i_delta_weight;
            tmp_output <= learning_rate
                       * ((s_delta_weight(2) + s_delta_weight(1))
                        + (s_delta_weight(0) + i_delta_weight));
        end if;
    end process mux4;

    o_dw_cumulation <= tmp_output(weight_int_w - 1 downto -weight_fract_w);
end rtl;
