
---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_bias.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier      : Huy-Hung Ho
-- @Created Date    : 10 Nov 2017    	@Modified Date : Nov 22 2017 15:30
-- @Project         : Neural Network
-- @Module          : NN_bias
-- Description:
--	Calculation of bias, when the select initial signal is active,
-- 	the output will the initial value of bias, and when the select update
--	signal is active, the output will be the new value of bias
--	Input:
--		i_dbias             : 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : delta bias2_1
--		clk                 : 1 bit
--		areset              : 1 bit : high active
--		i_select_initial	: 1 bit	: high active
--		i_select_update	    : 1 bit	: high active
--	Output:
--		o_bias		: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000 signed : bias2_1
-- @Version         : 0.1beta
-- @ID              : N/A
-- Modified         : Command bias for whole architecture
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use ieee.fixed_float_types.all;
---------------------------------------------------------------------------------
-- Entity declaration
---------------------------------------------------------------------------------
entity bias is
    generic (
        INIT_VALUE      : real := -1.0;
        INTEGER_WIDTH   : integer := 8;
        FLOAT_WIDTH     : integer := -24
    );
    port(
        clk              : in  std_logic;
        areset           : in  std_logic;
        i_select_initial : in  std_logic;
        i_select_update  : in  std_logic;
        i_dbias          : in  sfixed(INTEGER_WIDTH - 1 downto FLOAT_WIDTH);
        o_bias           : out sfixed(INTEGER_WIDTH - 1 downto FLOAT_WIDTH)
    );
end bias;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture beh of bias is
    signal bias_tmp	    : sfixed(INTEGER_WIDTH downto FLOAT_WIDTH);

    signal init_bias    : sfixed(INTEGER_WIDTH downto FLOAT_WIDTH)
        := to_sfixed(INIT_VALUE, INTEGER_WIDTH, FLOAT_WIDTH);
begin
	process(clk, areset)
	begin
        if(areset = '0') then
				bias_tmp <= (others => '0');
        elsif(rising_edge(clk)) then
            if(i_select_initial = '1') then
                bias_tmp <= init_bias;
            elsif (i_select_update = '1') then
                bias_tmp <= bias_tmp(INTEGER_WIDTH - 1 downto FLOAT_WIDTH) + i_dbias;
            else
                bias_tmp <= (others => '0');
            end if;
		end if;
	end process;

    o_bias <= bias_tmp(INTEGER_WIDTH - 1 downto FLOAT_WIDTH);
end beh;
