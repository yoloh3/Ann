--------------------------------------------------------------------------------
-- Project name   :
-- File name      : test_fixed_number.vhd
-- Created date   : Thu 16 Nov 2017 02:56:37 PM +07
-- Author         : Huy-Hung Ho
-- Last modified  : Thu 16 Nov 2017 02:56:37 PM +07
-- Desc           :
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;

entity fixed_number_tb is
    generic (
       INTEGER_WIDTH  : integer := 8;  
       FLOAT_WIDTH    : integer := 24
    );
end entity;

architecture behavior of fixed_number_tb is
    signal in_1:   ufixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    signal in_2:   ufixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    signal output: ufixed(INTEGER_WIDTH * 2 - 1 downto -FLOAT_WIDTH * 2);
begin
    process
    begin
        in_1 <= to_ufixed(4.2, in_1);
        in_2 <= to_ufixed(5.4, in_2);
        wait for 100 ps;
        output <= in_2 * in_1;
   end process;
end behavior;
