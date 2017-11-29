---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_t2.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier     	:
-- @Created Date    : 9 Nov 2017    	@Modified Date	:
-- @Project         : Neural Network
-- @Module          : NN_t2
-- @Description     : 8 bits memory to store value of t2
-- Input:
--	clk 	: 1 bit
--	din 	: 1 bit : read enable
--	addr	: 8 bits 0000.0000 : count number of clock with input from 0 to 15
-- Output:
--	t2	: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000	: output value for t2
-- @Version         : 0.1beta
-- @ID              : N/A
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------------
-- Entity declaration
---------------------------------------------------------------------------------
entity t2 is
port
(
	clk    : in std_logic;
	i_din  : in std_logic;
	i_addr : in unsigned(3 downto 0);
	o_t2   : out signed(31 downto 0)
);
end t2;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture beh of t2 is
type reg is array(15 downto 0) of signed(31 downto 0);
signal mem: reg;
begin
	t2: process(clk)
	begin
		if rising_edge(clk) then
			mem(0)  <= "00000000000000000000000000000000";	--t2= 0
			mem(1)  <= "00000001000000000000000000000000";	--t2= 1
			mem(2)  <= "00000001000000000000000000000000";	--t2= 1
			mem(3)  <= "00000001000000000000000000000000";	--t2= 1
			mem(4)  <= "00000000000000000000000000000000";
			mem(5)  <= "00000000000000000000000000000000";
			mem(6)  <= "00000000000000000000000000000000";
			mem(7)  <= "00000000000000000000000000000000";
			mem(8)  <= "00000000000000000000000000000000";
			mem(9)  <= "00000000000000000000000000000000";
			mem(10) <= "00000000000000000000000000000000";
			mem(11) <= "00000000000000000000000000000000";
			mem(12) <= "00000000000000000000000000000000";
			mem(13) <= "00000000000000000000000000000000";
			mem(14) <= "00000000000000000000000000000000";
			mem(15) <= "00000000000000000000000000000000";
		end if;
		if(i_din = '1') then
			o_t2
            <=
            mem(to_integer(i_addr));
		else
			o_t2 <= (others => 'Z');					--//when no control signal is given, tristate the output
		end if;
	end process t2;
end beh;