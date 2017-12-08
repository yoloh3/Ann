----------------------------------------------------------------------------------
--
-- Copyright (c) 2018 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : error_hidden.vhd
-- @Author          : Dung-Van Nguyen
-- @Modifier        : Huy-Hung Ho
-- @Created Date    : Wed 15 Nov 2017 10:11:32 PM DST
-- @Modified Date   : Nov 26 2017 07:02
-- @Project         : Neural Network
-- @Module          : error_hidden
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

entity error_hidden  is
    port (
        clk                  : in  std_logic;
        reset                : in  std_logic;
        i_dadz2              : in  dadz_float_t;
        i_weight_ouput_array : in  weight_array_t(layer_output_size - 1 downto 0);
        i_error_ouput_array  : in  error_array_t(layer_output_size - 1 downto 0);
        o_error_hidden       : out error_float_t
    );
end entity;

architecture rtl_error_hidden  of error_hidden  is
    constant mult_int_w       : integer := weight_int_w + error_int_w;
    constant mult_fract_w     : integer := weight_fract_w + error_fract_w;
    signal tmp_error_hidden_i :
        sfixed(mult_int_w + dadz_int_w - 1 downto -(mult_fract_w + dadz_fract_w));

    type mult_array_t is array (integer range <>)
        of sfixed(mult_int_w - 1 downto -mult_fract_w);
    signal s_mult_array: mult_array_t(layer_output_size - 1 downto 0);
begin
    mult_parallel: for i in 0 to layer_output_size - 1 generate
        s_mult_array(i) <= i_weight_ouput_array(i) * i_error_ouput_array(i);
    end generate mult_parallel;

    process(clk)
        variable v_tmp_sum    : sfixed(mult_int_w downto -mult_fract_w);
    begin
        if rising_edge(clk) then
            if(reset  = '1') then
                tmp_error_hidden_i  <= (others => '0');
                v_tmp_sum           := (others => '0');
            else
                v_tmp_sum           := (others => '0');
                for i in 0 to layer_output_size - 1 loop
                    v_tmp_sum := v_tmp_sum(mult_int_w - 1 downto -mult_fract_w)
                               + s_mult_array(i);
                end loop;

                tmp_error_hidden_i <= v_tmp_sum(mult_int_w - 1 downto
                                      -mult_fract_w)
                                    * i_dadz2;
            end if;
        end if;
    end process;

    o_error_hidden <= tmp_error_hidden_i(error_int_w - 1 downto -error_fract_w);
end rtl_error_hidden;
