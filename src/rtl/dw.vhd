----------------------------------------------------------------------------------
--
-- Copyright (c) 2018 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_dw.vhd
-- @Author          : Dung-Van Nguyen
-- @Modifier        :
-- @Created Date    : Thu 16 Nov 2017 11:30:22 AM DST
-- @Modified Date   : Thu 16 Nov 2017 11:30:22 AM DST
-- @Project         : Neural Network
-- @Module          : NN_dw
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

entity dw is
    generic (
        INTEGER_WIDTH   : integer := 8;
        FLOAT_WIDTH     : integer := 24
            );
    port (
        clk                 : in  std_logic;
        areset              : in  std_logic;
        i_unit_error        : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
        i_input_signal      : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
        o_renew_parameter   : out sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH)
    );
end entity;

architecture rtl_dw of dw  is
begin
    process(clk, areset)
    variable tmp_renew_parameter : sfixed(INTEGER_WIDTH*2 - 1 downto -(FLOAT_WIDTH*2));
    begin
        if rising_edge(areset) then
            tmp_renew_parameter := (others => '0');
        elsif rising_edge(clk) then
            tmp_renew_parameter := i_unit_error*i_input_signal;
        end if;
        o_renew_parameter <= tmp_renew_parameter(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    end process;
end rtl_dw;

