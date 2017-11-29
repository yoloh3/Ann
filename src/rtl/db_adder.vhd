----------------------------------------------------------------------------------
--
-- Copyright (c) 2018 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_db_adder.vhd
-- @Author          : Dung-Van Nguyen
-- @Modifier        :
-- @Created Date    : Thu 16 Nov 2017 11:55:25 AM DST
-- @Modified Date   : Thu 16 Nov 2017 11:55:25 AM DST
-- @Project         : Neural Network
-- @Module          : NN_db_adder
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

entity db_adder  is
    generic (
        INTEGER_WIDTH   : integer := 8;
        FLOAT_WIDTH     : integer := 24
            );
    port (
        clk     : in  std_logic;
        areset  : in  std_logic;
        i_delta : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
        o_dcdb  : out sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH)
    );
end entity;

architecture rtl_db_adder of db_adder  is
    constant counter_width : integer := 4;
    signal q : signed(counter_width-1 downto 0);
    signal delta_1 : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    signal delta_2 : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    signal delta_3 : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    signal delta_4 : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
begin
   counter: process(clk,areset)
    begin
        if(areset = '1') then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if q = to_signed(3, counter_width) then
                q <= (others => '0');
            else
                q <= q + to_signed(1, counter_width);
            end if;
        end if;
    end process counter;
    mux4: process(clk,areset)
    begin
        if areset = '1' then
            delta_1 <= (others => '0');
            delta_2 <= (others => '0');
            delta_3 <= (others => '0');
            delta_4 <= (others => '0');
        elsif rising_edge(clk) then
            if q = to_signed(0,4) then
                delta_1 <= i_delta;
            elsif q = to_signed(1,4) then
                delta_2 <= i_delta;
            elsif q = to_signed(2,4) then
                delta_3 <= i_delta;
            elsif q = to_signed(3,4) then
                delta_4 <= i_delta;
            else
                delta_1 <= (others => '0');
                delta_2 <= (others => '0');
                delta_3 <= (others => '0');
                delta_4 <= (others => '0');
            end if;
        end if;
    end process mux4;
    calcu: process(clk, areset)
    constant eta : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH) := to_sfixed(-0.1,INTEGER_WIDTH-1,-FLOAT_WIDTH); --eta = -0.1
    variable tmp_dcdb : sfixed(INTEGER_WIDTH*2 - 1 downto -(FLOAT_WIDTH*2));
    begin
        if areset = '1' then
           tmp_dcdb := (others => '0');
        elsif rising_edge(clk) then
          tmp_dcdb := eta*(delta_1 + delta_2 + delta_3 + delta_4);
        end if;
        o_dcdb <= tmp_dcdb(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    end process calcu;
end rtl_db_adder;
