
---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_b3_2.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier     	:
-- @Created Date    : 10 Nov 2017    	@Modified Date	:
-- @Project         : Neural Network
-- @Module          : NN_b3_2
-- Description:
--	Calculation of b3_2, when the select initial signal is active,
-- 	the output will the initial value of b3_2, and when the select update
--	signal is active, the output will be the new value of b3_2
--	Input:
--		i_db3_2		: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : delta bias2_1
--		clk		: 1 bit
--		areset		: 1 bit : high active
--		i_select_initial	: 1 bit	: high active
--		i_select_update	: 1 bit	: high active
--	Output:
--		o_b3_2		: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : bias2_1
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
entity b3_2 is
port(
	clk              : in  std_logic;
	areset           : in  std_logic;
	i_select_initial : in  std_logic;
	i_select_update  : in  std_logic;
	i_db3_2          : in  signed(31 downto 0);
	o_b3_2           : out signed(31 downto 0)
);
end b3_2;
---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture beh of b3_2 is
signal init_b3_2: signed(31 downto 0) := "11111111000000000000000000000000";

begin
	process(clk)
	variable net1		: signed(31 downto 0);
	variable net2		: signed(31 downto 0);
	variable b3_2_tmp	: signed(31 downto 0);

	begin
		if(rising_edge(clk)) then
			if(areset = '1') then
				net1 	:= (others => '0');
				net2	:= (others => '0');
				o_b3_2	<= (others => '0');
			else
				if(i_select_update = '1') then
					net1 := i_db3_2;
				else
					net1 := (others => '0');
				end if;
				net2 := b3_2_tmp + net1;
				if(i_select_initial = '1') then
					b3_2_tmp := init_b3_2;
				else
					b3_2_tmp := net2;
				end if;
				o_b3_2 <= b3_2_tmp;
			end if;
		end if;
	end process;
end beh;
