---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : derivative_activation_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Nov 30 2017       @Modified Date : Nov 30 2017 05:47
-- @Project         : Artificial Neural Network
-- @Module          : derivative_activation_tb
-- @Description     : Test bias with some input
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

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
entity derivative_activation_tb is
end entity;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of derivative_activation_tb is
    -- component declaration
    component derivative_activation
        port (
            clk                    : in  std_logic;
            reset                  : in  std_logic;
            i_a                    : in  activation_float_t;
            o_dadz                 : out dadz_float_t
        );
    end component derivative_activation;

    -- signal declaration
    signal s_clk       : std_logic := '0';
    signal s_reset     : std_logic := '1';
    signal s_i_a       : activation_float_t := (others => '0');
    signal s_o_dadz    : dadz_float_t       := (others => '0');

    constant period  : time := 100 ns;
begin
    -- unit under test
    dut: derivative_activation
        port map (
           clk                     => s_clk,
           reset                   => s_reset ,
           i_a                     => s_i_a,
           o_dadz                  => s_o_dadz                 
        );

    s_clk <= not(s_clk) after period / 2;
    s_reset  <= '0'     after period;

    stimulus: process
    begin
        wait until s_reset  = '0';

        -- -- Main simulation
        test_case_der_activ(s_clk, 1.5, s_o_dadz, -0.75, s_i_a);

        test_case_der_activ(s_clk, -2.5, s_o_dadz, -8.75, s_i_a);
    end process;
end bench;
