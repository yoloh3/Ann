---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by VLSI Systems Design Laboratory,
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : NN_selector.vhd
-- @Author          : Xuan-Thuan Nguyen      @Modifier           :
-- @Created Date    :   /  /             @Modified Date      :
-- @Project         : library
-- @module          : nn_selector
-- @description     : description of module.
-- @version         : 0.1beta
-- @id              : n/a
--
--------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------------------------------------------------------
-- entity declaration
--------------------------------------------------------------------------------- 
entity selecctor is
port
(
    clk             : in    std_logic;  
    areset          : in    std_logic;  
    enable_update   : out   std_logic  
);
end selecctor; 

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture beh of selecctor is
constant n : integer :=13;
signal counter : signed(7 downto 0);
begin
    count :process(clk, areset)
            begin
                if(rising_edge(clk)) then
                    if(areset = '1') then
                        counter <= (others => '0');
                    else
                        if(counter = to_signed((n-1),8)) then
                            counter <= (others => '0');
                        else
                            counter <= counter + to_signed(1,8);
                        end if;
                    end if;
                end if;
            end process count;

    enb_upd:process(clk, areset)
            begin
                if(rising_edge(clk)) then
                    if(areset = '1') then
                        enable_update <= '0';
                    else
                        if(counter = to_signed((n-1),8)) then
                            enable_update <= '1';
                        else
                            enable_update <= '0';
                        end if;
                    end if;
                end if;
            end process enb_upd;
end beh;
