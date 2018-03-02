---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NNa.vhd
-- @Author          : Xuan-Thuan Nguyen @Modifier      : Huy-Hung Ho
-- @Created Date    : 9 Nov 2017    	@Modified Date : Mar 02 2018 09:45
-- @Project         : Neural Network
-- @Module          : NN_activation_funct
-- @Description     : 8 bits memory to store value of activation_funct calculation.
-- Input:
--	clk	: 1 bit
--	din 	: 1 bit : read enable
--	addr 	: 8 bits 00000000 : value of activation_funct func with input from -8.0 to 7.93750
-- Output:
--	dout	: 32 bits 0000_0000.0000_0000_0000_0000_0000_0000	: output value for activation_funct func.
-- Latency: 1 clk
-- @Version         : 0.1beta
-- @ID              : N/A
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;

---------------------------------------------------------------------------------
-- Entity declaration
---------------------------------------------------------------------------------
entity activation_funct is
    port
    (
        clk                : in  std_logic;
        areset             : in  std_logic;
        i_weighted_input   : in  weighted_input_float_t;
        o_activation_funct : out activation_float_t
    );
end activation_funct;

---------------------------------------------------------------------------------
-- Function memory generate architecture description
---------------------------------------------------------------------------------
architecture funct of activation_funct is
    constant addr_int_w   : integer := 4;
    constant addr_fract_w : integer := 4;
    constant mem_depth    : integer := 2**(addr_int_w + addr_fract_w - 1);
    constant VALUE_0        : weighted_input_float_t := to_sfixed (0.0 ,  weighted_input_int_w - 1, - weighted_input_fract_w);
    constant VALUE_1_0      : weighted_input_float_t := to_sfixed (1.0 ,  weighted_input_int_w - 1, - weighted_input_fract_w);
    constant VALUE_3_5      : weighted_input_float_t := to_sfixed (3.5 ,  weighted_input_int_w - 1, - weighted_input_fract_w);
    constant VALUE_4_5      : weighted_input_float_t := to_sfixed (4.5 ,  weighted_input_int_w - 1, - weighted_input_fract_w);
    constant VALUE_1_0_NEG  : weighted_input_float_t := to_sfixed (-1.0,  weighted_input_int_w - 1, - weighted_input_fract_w);
    constant VALUE_3_5_NEG  : weighted_input_float_t := to_sfixed (-3.5,  weighted_input_int_w - 1, - weighted_input_fract_w);
    constant VALUE_4_5_NEG  : weighted_input_float_t := to_sfixed (-4.5,  weighted_input_int_w - 1, - weighted_input_fract_w);


    subtype output_type is sfixed(0 downto -activation_fract_w);
    type mem_type is array(0 to mem_depth - 1) of output_type;

    function init_mem1 return mem_type is
        variable temp_mem : mem_type;
    begin
        for i in 0 to 15 loop
            temp_mem(i) := to_sfixed(sigmoid_funct((real(i)/16.0 + 2.0)),
                0, -activation_fract_w);
        end loop;

        for i in 16 to 31 loop
            temp_mem(i) := to_sfixed(sigmoid_funct((real(i)/16.0)),
                0, -activation_fract_w);
        end loop;
        return temp_mem;
    end function;

    function init_mem2 return mem_type is
        variable temp_mem : mem_type;
    begin
        for i in 0 to 7 loop
            temp_mem(i) := to_sfixed(sigmoid_funct((real(i)/16.0 + 3.0)),
                0, -activation_fract_w);
        end loop;
        return temp_mem;
    end function;

    function init_mem3 return mem_type is
        variable temp_mem : mem_type;
    begin
        for i in 0 to 7 loop
            temp_mem(i) := to_sfixed(sigmoid_funct((real(i)/16.0 - 3.5)),
                0, -activation_fract_w);
        end loop;
        return temp_mem;
    end function;

    function init_mem4 return mem_type is
        variable temp_mem : mem_type;
    begin
        for i in 0 to 15 loop
            temp_mem(i) := to_sfixed(sigmoid_funct((real(i)/16.0 - 2.0)),
                0, -activation_fract_w);
        end loop;

        for i in 16 to 31 loop
            temp_mem(i) := to_sfixed(sigmoid_funct((real(i)/16.0 - 4.0)),
                0, -activation_fract_w);
        end loop;
        return temp_mem;
    end function;

    signal mem1    : mem_type := init_mem1;
    signal mem2    : mem_type := init_mem2;
    signal mem3    : mem_type := init_mem3;
    signal mem4    : mem_type := init_mem4;

    signal mem_pos : output_type;
    signal mem_neg : output_type;
    signal control : std_logic_vector (0 to 5);

    signal output_funct_opt : output_type;

    subtype address_t is std_logic_vector (addr_int_w + addr_fract_w - 1 downto 0);
    signal address : address_t;
begin

    control(0) <= '1' when i_weighted_input < VALUE_4_5 else '0';
    control(1) <= '1' when i_weighted_input < VALUE_3_5 else '0';
    control(2) <= '1' when i_weighted_input < VALUE_1_0 else '0';
    control(3) <= '1' when i_weighted_input < VALUE_1_0_NEG else '0';
    control(4) <= '1' when i_weighted_input < VALUE_3_5_NEG else '0';
    control(5) <= '1' when i_weighted_input < VALUE_4_5_NEG else '0';

    address <= address_t(i_weighted_input(addr_int_w - 1 downto -addr_fract_w));

    mem_pos <= mem1(to_integer(unsigned(address(4 downto 0))))
                when (i_weighted_input(1) xor i_weighted_input(0)) = '1' else
               mem2(to_integer(unsigned(address(2 downto 0))));

    mem_neg <= mem3(to_integer(unsigned(address(2 downto 0))))
                when (i_weighted_input(1) xor i_weighted_input(0)) = '0' else
               mem4(to_integer(unsigned(address(4 downto 0))));

    process(areset , clk)
        variable output_tmp : sfixed(activation_int_w downto -activation_fract_w);
    begin
        if areset  = '1' then
            output_funct_opt    <= (others => '0');

        elsif rising_edge(clk) then
            case control is
                 when "000000" =>
                    output_funct_opt <= to_sfixed(0.9990234, 0, - activation_fract_w);
                 when "100000" =>
                    output_funct_opt <= to_sfixed(0.984375, 0, - activation_fract_w);
                 when "110000" =>
                    output_funct_opt <= mem_pos;
                 when "111000" =>
                     output_tmp := i_weighted_input(3) & i_weighted_input(3)
                                 & i_weighted_input(3) &  i_weighted_input(3)
                                 & i_weighted_input(3) & i_weighted_input
                                 & "0000";

                    output_tmp := output_tmp(activation_int_w -1 downto -activation_fract_w)
                                + to_sfixed(0.5, activation_int_w -1, -activation_fract_w);

                    output_funct_opt <= output_tmp(0 downto -activation_fract_w);
                 when "111100" =>
                    output_funct_opt <= mem_neg;
                 when "111110" =>
                    output_funct_opt <= to_sfixed (0.015625, 0, - activation_fract_w);
                 when others =>
                    output_funct_opt <= to_sfixed (0.0, 0, - activation_fract_w);
            end case;
        end if;
    end process;

    o_activation_funct <= "00000" & output_funct_opt
                            when output_funct_opt(0) = '0' else
                          "11111" & output_funct_opt ;
end funct;
