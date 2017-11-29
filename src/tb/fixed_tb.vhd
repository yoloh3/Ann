--------------------------------------------------------------------------------
-- Project name   :
-- File name      : fixed_tb.vhd
-- Created date   : Sat 18 Nov 2017 04:01:56 PM +07
-- Author         : Huy-Hung Ho
-- Last modified  : Sat 18 Nov 2017 04:01:56 PM +07
-- Desc           :
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.fixed_float_types.all;

entity fixed_tb is
end entity;

architecture behavior of fixed_tb is
    signal  s_data_in_1 : sfixed (7 downto -24);
    signal  s_data_in_2 : sfixed (7 downto -24);
    signal  s_multilier : sfixed (15 downto -48);
    signal  s_data_out : sfixed (7 downto -24);
begin
    process
    begin
        wait for 100 ns;
        s_data_in_1 <= to_sfixed(0.5, s_data_in_1);
        s_data_in_2 <= to_sfixed(2.1, s_data_in_2);
        wait for 100 ns;
        s_data_in_1 <= to_sfixed(-7.4, s_data_in_1);
        s_data_in_2 <= to_sfixed(2.12, s_data_in_2);
   end process;

   s_multilier <= s_data_in_1 * s_data_in_2;
   s_data_out <= s_multilier(7 downto -24);
end behavior;

