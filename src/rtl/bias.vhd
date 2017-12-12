---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : bias.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier      : Huy-Hung Ho
-- @Created Date    : 10 Nov 2017       @Modified Date : Nov 22 2017 15:30
-- @Project         : Artificial Neural Network
-- @Module          : bias
-- Description:
--  Calculation of bias, when the select initial signal is active,
--  the output will the initial value of bias, and when the select update
--  signal is active, the output will be the new value of bias
--  Input:
--      i_dbias             : 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : delta bias2_1
--      clk                 : 1 bit
--      reset               : 1 bit : high active
--      i_select_initial    : 1 bit : high active
--      i_select_update     : 1 bit : high active
--  Output:
--      o_bias      : 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : bias2_1
-- @Version         : 0.1beta
-- @ID              : N/A
-- Modified         : Command bias for whole architecture
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
entity bias is
    generic (
        init_value      : real    := -1.0
    );
    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        i_select_initial : in  std_logic;
        i_select_update  : in  std_logic;
        i_dbias          : in  bias_float_t;
        o_bias           : out bias_float_t
    );
end bias;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture rtl of bias is
    -- signal is 33 bit for sum
    signal bias_tmp     : sfixed(bias_int_w downto -bias_fract_w);

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(reset  = '1') then
                    bias_tmp <= (others => '0');
            elsif(i_select_initial = '1') then
                bias_tmp <= to_sfixed(init_value, bias_tmp);
            elsif (i_select_update = '1') then
                bias_tmp <= bias_tmp(bias_int_w - 1 downto -bias_fract_w) + i_dbias;
            else
                bias_tmp <= bias_tmp;
            end if;
        end if;
    end process;

    o_bias <= bias_tmp(bias_int_w - 1 downto -bias_fract_w);
end rtl;
