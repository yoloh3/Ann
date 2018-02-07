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
architecture funct of sc_sigmoid is
    constant mem_depth    : integer := 2**sc_data_width;
    type mem_type is array(0 to mem_depth - 1) of sc_float_t;

    function init_mem return mem_type is
        variable temp_mem : mem_type;
        variable input_real : real := 0.0;
    begin
        for i in 0 to mem_depth - 1 loop
            input_real := 4.0  * (real(i) / 2.0**(sc_data_width - 1) - 1.0);

            temp_mem(i) := real_sign_to_stdlv(sigmoid_funct(input_real),
                                              sc_data_width);
        end loop;
        return temp_mem;
    end function;

    signal mem: mem_type := init_mem;
begin
    process(areset , clk)
    begin
        if areset  = '0' then
            o_sc_sigmoid <= (others => '0');
        elsif rising_edge(clk) then
            if i_start = '1' then
                o_sc_sigmoid <= mem(to_integer(unsigned(i_weighted_input)));
            end if;
        end if;
    end process;
end funct;
