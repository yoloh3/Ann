---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : mem_tb.vhd
-- @Author          : Huy-Hung Ho @Modifier      : Huy-Hung Ho
-- @Created Date    : Nov 22 2017      @Modified Date : Nov 22 2017 14:27
-- @Project         : Artificial Neural Network
-- @Module          : mem_tb
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

---------------------------------------------------------------------------------
-- Entity declaration
--------------------------------------------------------------------------------- 
entity mem_tb is
    generic (ADDR_WIDTH : integer := 8;
             DATA_WIDTH : integer := 8
    );
    port(
        clk     : in std_logic;
        rst     : in std_logic
    );
end entity; 

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture behavior of mem_tb is
    constant MEM_DEPTH : integer := 2**ADDR_WIDTH;
type mem_type is array (0 to MEM_DEPTH-1) of signed(DATA_WIDTH-1 downto 0);

function init_mem return mem_type is
    constant SCALE : real := 2**(real(DATA_WIDTH-2));
    constant STEP  : real := 1.0/real(MEM_DEPTH);
    variable temp_mem : mem_type;
begin
    for i in 0 to MEM_DEPTH-1 loop
        temp_mem(i) := to_signed(integer(cos(2.0*MATH_PI*real(i)*STEP)*SCALE), DATA_WIDTH);
    end loop;
    return temp_mem;
end;

constant mem : mem_type := init_mem;
begin

end behavior;

