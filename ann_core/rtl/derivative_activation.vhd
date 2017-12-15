---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : derivative_activation.vhd
-- @Author          : Nguyen Van-Dung  @Modifier      : Huy-Hung Ho
-- @Created Date    : 15 Nov 2017      @Modified Date : Nov 27 2017 06:18
-- @Project         : Neural Network
-- @Module          : derivative_activation
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
entity derivative_activation is
    port(
        clk    : in  std_logic;
        areset : in  std_logic;
        i_a    : in  activation_float_t;
        o_dadz : out dadz_float_t
    );
end derivative_activation;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture rtl of derivative_activation is
    signal tmp_dadz :
        sfixed(2 * activation_int_w downto - 2 *activation_fract_w);
begin
    derivative_activation: process(clk, areset)
    begin
        if areset = '1' then
            tmp_dadz <= (others => '0');
        elsif rising_edge(clk) then
            tmp_dadz <= (to_sfixed(1.0, i_a) - i_a) * i_a;
        end if;
    end process;

    o_dadz <= tmp_dadz(dadz_int_w - 1 downto -dadz_fract_w);
end rtl;
