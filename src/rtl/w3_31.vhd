
---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_w3_31.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier     	:
-- @Created Date    : 10 Nov 2017    	@Modified Date	:
-- @Project         : Neural Network
-- @Module          : NN_w3_31
-- Description:
--		Calculation of w3_31, when the select initial signal is active,
-- 		the output will the initial value of w3_31, and when the select update
--		signal is active, the output will be the new value of w3_31
--	Input:
--		dw3_31	: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : delta weight2_11
--		clk	: 1 bit
--		reset	: 1 bit : high active
--		i_select_initial	: 1 bit	: high active
--		i_select_update	: 1 bit	: high active
--	Output:
--		w3_31	: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : weight2_11
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
entity w3_31 is
port(
	clk              : in  std_logic;
	areset           : in  std_logic;
	i_select_initial : in  std_logic;
	i_select_update  : in  std_logic;
	i_dw3_31         : in  signed(31 downto 0);
	o_w3_31          : out signed(31 downto 0)
);
end w3_31;
---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture beh of w3_31 is
signal init_w3_31: signed(31 downto 0) := "00000001010011001100110011001100";

begin
	process(clk)
	variable net1		: signed(31 downto 0);
	variable net2		: signed(31 downto 0);
	variable w3_31_tmp	: signed(31 downto 0);

	begin
		if(rising_edge(clk)) then
			if(areset = '1') then
				net1 	:= (others => '0');
				net2	:= (others => '0');
				o_w3_31	<= (others => '0');
			else
				if(i_select_update = '1') then
					net1 := i_dw3_31;
				else
					net1 := (others => '0');
				end if;
				net2 := w3_31_tmp + net1;
				if(i_select_initial = '1') then
					w3_31_tmp := init_w3_31;
				else
					w3_31_tmp := net2;
				end if;
				o_w3_31 <= w3_31_tmp;
			end if;
		end if;
	end process;
end beh;
