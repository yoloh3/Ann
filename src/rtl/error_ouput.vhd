---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : error_ouput.vhd
-- @Author          : Nguyen Van-Dung  @Modifier      : Huy-Hung Ho
-- @Created Date    : 15 Nov 2017      @Modified Date : xim 30 2017 09:31
-- @Project         : Neural Network
-- @Module          : error_ouput
-- @Description     : Description of module.
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
entity error_ouput is
    port(
        clk                : in  std_logic;
        areset             : in  std_logic;
        i_activation_ouput : in  activation_float_t;
        i_exptected_value  : in  input_float_t;
        i_dadz_ouput       : in  dadz_float_t;
        o_error_ouput      : out error_float_t
      );
end error_ouput;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture rtl of error_ouput is
    signal tmp_error_ouput :
        sfixed(dadz_int_w + input_int_w
            downto - (dadz_fract_w + input_fract_w));
begin
    process(clk, areset)
    begin
        if areset = '1' then
            tmp_error_ouput <= (others => '0');
        elsif rising_edge(clk) then
            tmp_error_ouput <= i_dadz_ouput
                            * (i_activation_ouput - i_exptected_value);
        end if;
    end process;

    o_error_ouput <= tmp_error_ouput(error_int_w - 1 downto -error_fract_w);
end rtl;
