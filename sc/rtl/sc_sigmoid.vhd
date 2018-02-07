---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : sc_sigmoid.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Feb 05 2018       @Modified Date : Feb 05 2018 16:33
-- @Project         : Artificial Neural Network
-- @Module          : sc_sigmoid
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.sc_rtl_pkg.all;
use work.sc_tb_pkg.all;

---------------------------------------------------------------------------------
-- Entity declaration
---------------------------------------------------------------------------------
entity sc_sigmoid is
    port
    (
        clk                : in  std_logic;
        areset             : in  std_logic;
        i_start            : in  std_logic;
        i_weighted_input   : in  sc_float_t;
        o_sc_sigmoid       : out sc_float_t
    );
end sc_sigmoid;

---------------------------------------------------------------------------------
-- Function memory generate architecture description
---------------------------------------------------------------------------------
architecture behavior of sc_sigmoid is
begin
    process(areset , clk)
        variable v_tmp: real;
    begin
        if(areset = '0') then
           o_sc_sigmoid <= (others => '0');
        elsif rising_edge(clk) then
            if i_start = '1' then
                v_tmp := 4.0 * stdlv_sign_to_real(i_weighted_input);
                o_sc_sigmoid <= real_sign_to_stdlv(sigmoid_funct(v_tmp), sc_data_width);
            end if;
        end if;
    end process;

end behavior;
