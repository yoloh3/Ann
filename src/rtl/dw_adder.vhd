---------------------------------------------------------------------------------
--
-- Copyright (c) 2018 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_dw_adder.vhd
-- @Author          : Dung-Van Nguyen
-- @Modifier        :
-- @Created Date    : Thu 16 Nov 2017 04:01:14 PM DST
-- @Modified Date   : Thu 16 Nov 2017 04:01:14 PM DST
-- @Project         : Neural Network
-- @Module          : NN_dw_adder
-- @Description     : Description of module.
-- @Version         : 0.1beta
-- @ID              : N/A
--
---------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
use ieee.numeric_std.all;

entity dw_adder  is
    generic(
        INTEGER_WIDTH : integer := 8;
        FLOAT_WIDTH   : integer := 24
           );
    port (
        clk      : in  std_logic;
        areset   : in  std_logic;
        i_dw     : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
        o_dcdw3  : out sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH)
    );
end entity;

architecture rtl_dw_adder  of dw_adder  is
    signal q : signed(3 downto 0);
    signal delta3a2_1 : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    signal delta3a2_2 : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    signal delta3a2_3 : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    signal delta3a2_4 : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
begin
    couter: process(clk,areset)
    begin
        if areset = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if q = to_signed(3,4) then
                q <= (others => '0');
            else
                q <= q + to_signed(1,4);
            end if;
        end if;
    end process couter;
    mux4: process(clk, areset)
    begin
        if areset = '1' then
            delta3a2_1 <= (others => '0');
            delta3a2_2 <= (others => '0');
            delta3a2_3 <= (others => '0');
            delta3a2_4 <= (others => '0');
        elsif rising_edge(clk) then
            if q = to_signed(0,4) then
                delta3a2_1 <= i_dw;
            elsif q = to_signed(1,4) then
                delta3a2_2 <= i_dw;
            elsif q = to_signed(2,4) then
                delta3a2_3 <= i_dw;
            elsif q = to_signed(3,4) then
                delta3a2_4 <= i_dw;
            else
                delta3a2_1 <= (others => '0');
                delta3a2_2 <= (others => '0');
                delta3a2_3 <= (others => '0');
                delta3a2_4 <= (others => '0');
            end if;
        end if;
    end process mux4;
    calcu: process(clk, areset)
    constant eta : sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH) := to_sfixed(-0.1,INTEGER_WIDTH-1,-FLOAT_WIDTH);
    variable tmp_dcdw3 : sfixed(INTEGER_WIDTH*2-1 downto -(FLOAT_WIDTH*2));
    begin
        if areset = '1' then
            tmp_dcdw3 := (others => '0');
        elsif rising_edge(clk) then
            tmp_dcdw3 := eta*(delta3a2_1 + delta3a2_2 + delta3a2_3 + delta3a2_4);
        end if;
        o_dcdw3 <= tmp_dcdw3(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    end process calcu;
end rtl_dw_adder;

