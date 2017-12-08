----------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : delta_weight.vhd
-- @Author          : Dung-Van Nguyen
-- @Modifier        : Huy-Hung Ho
-- @Created Date    : Thu 16 Nov 2017 11:30:22 AM DST
-- @Modified Date   : Nov 27 2017 06:20
-- @Project         : Neural Network
-- @Module          : delta_weight
-- @Description     : Description of module.
-- @Version         : 0.1beta
-- @ID              : N/A
--
---------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;

entity delta_weight is
    port (
        clk            : in  std_logic;
        reset          : in  std_logic;
        i_error        : in  error_float_t;
        i_input_signal : in  input_float_t;
        o_delta_weight : out weight_float_t
    );
end entity;

architecture rtl of delta_weight  is
    signal tmp_delta_weight :
        sfixed(error_int_w + input_int_w - 1
            downto -(error_fract_w + input_fract_w));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset  = '1' then
                tmp_delta_weight <= (others => '0');
            else
                tmp_delta_weight <= i_error * i_input_signal;
            end if;
        end if;
    end process;

    o_delta_weight <= tmp_delta_weight(weight_int_w - 1 downto -weight_fract_w);
end rtl;

