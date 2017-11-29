---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_k1.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier     	:
-- @Created Date    : 9 Nov 2017    	@Modified Date	:
-- @Project         : Neural Network
-- @Module          : NN_k1
-- @Description     : 8 bits memory to store value of k1
-- Input:
--	clk 	: 1 bit
--	din 	: 1 bit : read enable
--	addr	: 8 bits 0000.0000 : count number of clock with input from 0 to 15
-- Output:
--	k1	: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000	: output value for k1
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
entity k1 is
port
(
	clk    : in std_logic;
	i_din  : in std_logic;
	i_addr : in unsigned(3 downto 0);
	o_k1   : out signed(31 downto 0)
);
end k1;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture beh of k1 is
type reg is array(15 downto 0) of signed(31 downto 0);
signal mem: reg;
begin
	k1: process(clk)
	begin
		if rising_edge(clk) then
			mem(0)  <= "00001000000000000000000000000000";	--k1= 8
			mem(1)  <= "00001000000000000000000000000000";	--k1= 8
			mem(2)  <= "00000101000000000000000000000000";	--k1= 5
			mem(3)  <= "00000101000000000000000000000000";	--k1= 5
			mem(4)  <= "00000000000000000000000000000000";	--k1= 0
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
			o_k1
            <=
            mem(to_integer(i_addr));
		else
			o_k1 <= (others => 'Z');					--//when no control signal is given, tristate the output
		end if;
	end process k1;
end beh;

