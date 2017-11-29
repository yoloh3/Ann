---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : sigmoid_lut
-- @Author          : Xuan-Thuan Nguyen @Modifier      : Huy-Hung Ho
-- @Created Date    : 9 Nov 2017    	@Modified Date : Nov 19 2017 08:35
-- @Project         : Neural Network
-- @Module          : sigmoid_lut 
-- @Description     : 8 bits memory to store value of sigmoid calculation.
-- Input:
--	clk	    : 1 bit
--	din 	: 1 bit : read enable
--	addr 	: 8 bits 00000000 : value of sigmoid func with input from -8.0 to 7.93750
-- Output:
--	dout	: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000	: output value for sigmoid func.
-- Latency  : 1 clk
-- @Version : 0.1beta
-- @ID      : N/A
-- Modified : Edit from fixed value to using initiation function
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.fixed_pkg.all;
use ieee.fixed_float_types.all;

---------------------------------------------------------------------------------
-- Entity declaration
---------------------------------------------------------------------------------
entity sigmoid_lut is
    generic (
        ADDR_WIDTH  : integer := 8;
        INTEGER_WIDTH: integer := 8;
        FLOAT_WIDTH  : integer := -24
    );
    port (
        clk    : in  std_logic;
        i_din  : in  std_logic;
        i_addr : in  unsigned(ADDR_WIDTH - 1 downto 0);
        o_dout : out sfixed(INTEGER_WIDTH - 1 downto FLOAT_WIDTH)
    );
end sigmoid_lut;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture beh of sigmoid_lut is
    constant MEM_DEPTH  : integer := 2**ADDR_WIDTH;
    type mem_type is array(0 to MEM_DEPTH - 1)
        of sfixed(INTEGER_WIDTH - 1 downto FLOAT_WIDTH);

    function init_mem return mem_type is
        variable temp_mem : mem_type;
    begin
        for i in 0 to MEM_DEPTH / 2 - 1 loop
            temp_mem(i) := to_sfixed(1.0 / (1.0 + exp(-(real(i)/16.0))),
                INTEGER_WIDTH - 1, FLOAT_WIDTH);
        end loop;
        for i in MEM_DEPTH / 2 to MEM_DEPTH - 1 loop
            temp_mem(i) := to_sfixed(1.0 / (1.0 + exp(-(real(i-MEM_DEPTH)/16.0))),
                INTEGER_WIDTH - 1, FLOAT_WIDTH);
        end loop;
        return temp_mem;
    end function;

    signal mem: mem_type := init_mem;
begin
	process(clk)
	begin
      if rising_edge(clk) then
			  if(i_din = '1') then
				  o_dout <= mem(to_integer(i_addr));
			  else
				  o_dout <= (others => 'Z');
			  end if;
		  end if;
	end process;
end beh;
