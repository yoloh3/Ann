---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : NN_counter.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier           :
-- @Created Date    : 9 Nov 2017    	@Modified Date      :
-- @Project         : Neural Network
-- @Module          : NN_counter
-- @Description     : counter for signal to insert in k1, k2, t1 and t2
-- Input:
--	clk	: 1 bit
--	reset 	: 1 bit : high active
-- Output: 
--	out	: 4 bit : high active
-- Latency:
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
entity counter is
port
(
	clk	: in std_logic; 
	areset	: in std_logic;
	o_out	: out unsigned(3 downto 0)
  );
end counter; 

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture beh of counter is
constant N : integer := 13;
begin
	process(clk, areset)
	variable out_tmp : unsigned (3 downto 0);
	begin
		if rising_edge(clk) then
			if(areset = '1') then
				out_tmp := (others => '0');
			elsif (out_tmp = to_unsigned((N-1),4)) then
				out_tmp := (others => '0');
			else
				out_tmp := out_tmp + "0001";
			end if;
		end if;
		o_out <= out_tmp;
	end process;
end beh;
