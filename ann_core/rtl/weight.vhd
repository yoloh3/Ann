---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_w2_11.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier       :
-- @Created Date    : 10 Nov 2017       @Modified Date  :
-- @Project         : Neural Network
-- @Module          : NN_w2_11
-- Description:
--      Calculation of w2_11, when the select initial signal is active,
--      the output will the initial value of w2_11, and when the select update
--      signal is active, the output will be the new value of w2_11
--  Input:
--      dw2_11  : 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : delta weight2_11
--      clk : 1 bit
--      reset   : 1 bit : high active
--      i_select_initial    : 1 bit : high active
--      i_select_update : 1 bit : high active
--  Output:
--      w2_11   : 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : weight2_11
-- @Version         : 0.1beta
-- @ID              : N/A
--
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
entity weight is
    generic (
        init_value       : real    := -1.0
    );
    port(
        clk              : in  std_logic;
        areset           : in  std_logic;
        i_select_initial : in  std_logic;
        i_select_update  : in  std_logic;
        i_dweight        : in  weight_float_t;
        o_weight         : out weight_float_t
    );
end weight;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture rtl of weight is
    -- signal is 33 bit for sum
    signal weight_tmp  : sfixed(weight_int_w downto -weight_fract_w);

begin
    process(clk, areset)
    begin
        if(areset = '1') then
            weight_tmp <= (others => '0');
        elsif(rising_edge(clk)) then
            if(i_select_initial = '1') then
                    weight_tmp <= to_sfixed(init_value, weight_tmp);

            elsif (i_select_update = '1') then
                weight_tmp <= weight_tmp(weight_int_w - 1 downto -weight_fract_w)
                            + i_dweight;
            else
                weight_tmp <= weight_tmp;
            end if;
        end if;
    end process;

    o_weight <= weight_tmp(weight_int_w - 1 downto -weight_fract_w);
end rtl;
