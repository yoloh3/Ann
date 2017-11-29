---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_z2.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier     	:
-- @Created Date    : 9 Nov 2017    	@Modified Date	:
-- @Project         : Neural Network
-- @Module          : NN_z2
-- @Description     : Calculation of 2 input (k1,k2) and 1 output (z2)
-- Input:
--	ki		: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed 	: input data (i=1,2)
--	b2		: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed 	: bias value
--	w2_i		: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed 	: weight value (i=1,2)
--	clk		: 1 bit
--	areset		: 1 bit : high active
-- Output:
--	z2		: 8 bits 0000.0000 : output value
-- Latency: 1 clk
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
entity z2 is
port
(
	clk    : in  std_logic;
	areset : in  std_logic;
	i_k1   : in  signed(31 downto 0);
	i_k2   : in  signed(31 downto 0);
	i_w2_1 : in  signed(31 downto 0);
	i_w2_2 : in  signed(31 downto 0);
	i_b2   : in  signed(31 downto 0);
	o_z2   : out signed(7 downto 0)
);
end z2;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture rtl_z2 of z2 is
	signal z2_tmp	: signed(31 downto 0);
begin
	z2: process(clk, areset, i_k1, i_w2_1, i_k2, i_w2_2, i_b2)
	variable net1	: signed(63 downto 0);
	variable net2	: signed(63 downto 0);

	begin
		if(areset = '1') then
			net1 := (others =>'0');
			net2 := (others =>'0');
			z2_tmp <= (others =>'0');
		elsif rising_edge(clk) then
			net1 := i_k1*i_w2_1;
			net2 := i_k2*i_w2_2;
			z2_tmp <= net1(55 downto 24) + net2(55 downto 24) + i_b2;
		end if;
	end process z2;
	o_z2 <= z2_tmp(27 downto 20);
end rtl_z2;
