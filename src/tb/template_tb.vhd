---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
-- -- Copyright notification -- No part may be reproduced except as authorized by written permission.
--
-- @File            : !!FILE
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : !!DATE       @Modified Date : !!DATE
-- @Project         : Artificial Neural Network
-- @Module          : !!MODULE
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
library ieee;
use std.textio.all;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.numeric_std.all;
use work.rtl_pkg.all;
use work.tb_pkg.all;

---------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------
entity !!MODULE is
end entity;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of !!MODULE is
    -- component declaration


    -- signal declaration

    signal s_clk      : std_logic := '0';
    signal s_areset   : std_logic := '1';
    constant period : time := 100 ns;
begin
    -- device unit test


    s_clk <= not(s_clk) after period / 2;
    s_areset <= '0'     after period;

    stimulus: process
    begin
        wait until s_areset = '0';

        -- -- Main simulation
        test_case_der_activ(s_clk, 1.5, s_o_dadz, -0.75, s_i_a);

    end process;
end bench;
