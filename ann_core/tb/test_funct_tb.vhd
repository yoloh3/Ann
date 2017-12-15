---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : test_funct_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : xim 30 2017       @Modified Date : xim 30 2017 14:03
-- @Project         : Artificial Neural Network
-- @Module          : test_funct_tb
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;

entity fixed_number_tb is
    generic (
       integer_width : integer := 8;
       float_width   : integer := 24
    );
end entity;

architecture behavior of fixed_number_tb is
    signal in_1   : ufixed(integer_width - 1 downto -float_width);
    signal in_2   : ufixed(integer_width - 1 downto -float_width);
    signal output : ufixed(integer_width * 2 - 1 downto -float_width * 2);
begin
    process
    begin
        in_1 <= to_ufixed(4.2, in_1);
        in_2 <= to_ufixed(5.4, in_2);
        wait for 100 ps;
        output <= in_2 * in_1;
   end process;
end behavior;


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
    signal  s_data_out  : sfixed (7 downto -24);
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
