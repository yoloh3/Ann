----------------------------------------------------------------------------------
--
-- Copyright (c) 2018 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_delta2.vhd
-- @Author          : Dung-Van Nguyen
-- @Modifier        :
-- @Created Date    : Wed 15 Nov 2017 10:11:32 PM DST
-- @Modified Date   : Wed 15 Nov 2017 10:11:32 PM DST
-- @Project         : Neural Network
-- @Module          : NN_delta2
-- @Description     : Description of module.
-- @Version         : 0.1beta
-- @ID              : N/A
--
---------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;

entity delta2  is
    generic (
        INTEGER_WIDTH   : integer := 8;
        FLOAT_WIDTH     : integer := 24
            );
    port (
        clk        : in  std_logic;
        areset     : in  std_logic;
        i_dadz2_i  : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
        i_w3_i1    : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
        i_w3_i2    : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
        i_delta3_1 : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
        i_delta3_2 : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
        o_delta2_i : out sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH)
    );
end entity;

architecture rtl_delta2  of delta2  is
signal tmp_delta2_i : sfixed(INTEGER_WIDTH*3 - 1 downto -(FLOAT_WIDTH*3));
begin
    process(clk, areset)
    begin
        if(areset = '1') then
            tmp_delta2_i <= (others => '0');
        elsif rising_edge(clk) then
            tmp_delta2_i <= (i_w3_i1*i_delta3_1 + i_w3_i2*i_delta3_2)*i_dadz2_i;
        end if;
        o_delta2_i <= tmp_delta2_i(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    end process;
end rtl_delta2;

