---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_z3.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier     	:
-- @Created Date    : 9 Nov 2017    	@Modified Date	:
-- @Project         : Neural Network
-- @Module          : NN_z3
-- @Description     : Calculation of 3 input (a2) and 1 output (z3)
-- Input:
--	a2_i		: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed 	: input data (i=1,2,3)
--	b3		: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed 	: bias value
--	w3_i		: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed 	: weight value (i=1,2,3)
--	clk		: 1 bit
--	areset		: 1 bit : high active
-- Output:
--	z3		: 8 bits 0000.0000 : output value
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
entity z3 is
port
(
	clk    : in  std_logic;
	areset : in  std_logic;
	i_a2_1 : in  signed(31 downto 0);
	i_a2_2 : in  signed(31 downto 0);
	i_a2_3 : in  signed(31 downto 0);
	i_w3_1 : in  signed(31 downto 0);
	i_w3_2 : in  signed(31 downto 0);
	i_w3_3 : in  signed(31 downto 0);
	i_b3   : in  signed(31 downto 0);
	o_z3   : out signed(7 downto 0)
);
end z3;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture beh_z3 of z3 is
	signal z3_tmp	: signed(31 downto 0);
begin
	z3: process(clk, areset, i_a2_1, i_w3_1, i_a2_2, i_w3_2, i_a2_3, i_w3_3)
	variable net1	: signed(63 downto 0);
	variable net2	: signed(63 downto 0);
	variable net3	: signed(63 downto 0);
	begin
		if(areset='1') then
			net1 := (others => '0');
			net2 := (others => '0');
			net3 := (others => '0');
			z3_tmp <= (others => '0');
		elsif rising_edge(clk) then
			net1 := i_a2_1*i_w3_1;
			net2 := i_a2_2*i_w3_2;
			net3 := i_a2_3*i_w3_3;
			z3_tmp <= (net1(55 downto 24) + net2(55 downto 24) + net3(55 downto 24) + i_b3);
		end if;
	end process z3;
	o_z3 <= z3_tmp(27 downto 20);
end beh_z3;
