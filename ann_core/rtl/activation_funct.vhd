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
-- @Author          : Xuan-Thuan Nguyen @Modifier           :
-- @Created Date    : 9 Nov 2017    	@Modified Date      :
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
    constant mem_depth    : integer := 2**(addr_int_w + addr_fract_w);
    type mem_type is array(0 to mem_depth - 1) of activation_float_t;

    function init_mem return mem_type is
        variable temp_mem : mem_type;
    begin
        for i in 0 to mem_depth / 2 - 1 loop
            temp_mem(i) := to_sfixed(1.0 / (1.0 + exp(-(real(i)/2.0**addr_fract_w))),
                activation_int_w - 1, -activation_fract_w);
        end loop;
        for i in mem_depth / 2 to mem_depth - 1 loop
            temp_mem(i) := to_sfixed(1.0 / (1.0 + exp((real(i-mem_depth/2)/2.0**addr_fract_w))),
                activation_int_w - 1, -activation_fract_w);
        end loop;

        return temp_mem;
    end function;

    signal mem: mem_type := init_mem;
begin
    process(areset , clk)
        subtype address_t is std_logic_vector (i_weighted_input'length - 1 downto 0);
        variable address : address_t;
    begin
        if rising_edge(clk) then
            if areset  = '1' then
                o_activation_funct <= (others => '0');
            else
                address := address_t(i_weighted_input);
                o_activation_funct <= mem(to_integer(unsigned(address)));
            end if;

        end if;
    end process;
end funct;

architecture hierarchy of activation_funct is
    constant OUTPUT_OF_SATURATION       : real := 0.96875;
    constant PASS_REGION_BOUNDARY       : real := 0.5;
    constant PROCESSING_REGION_BOUNDARY : real := 2.0;
    constant SATURATION_REGION_BOUNDARY : real := 8.0;
    constant ZERO                       : real := 0.0;
begin
    SIGMOID_FUNC : process (clk, rst, i_weighted_input) 
    begin
        if i_weighted_input >= 0 or i_weighted_input < PASS_REGION_BOUNDARY  then
            o_activation_funct <= i_weighted_input;
        elsif i_weighted_input >= PASS_REGION_BOUNDARY or i_weighted_input <
        PROCESSING_REGION_BOUNDARY then
            
        elsif i_weighted_input >= PROCESSING_REGION_BOUNDARY or
            i_weighted_input < SATURATION_REGION_BOUNDARY then
             o_activation_funct <= OUTPUT_OF_SATURATION;
        end if;
    end process SIGMOID_FUNC;
end hierarchy;
---------------------------------------------------------------------------------
-- Specifier architecture description
---------------------------------------------------------------------------------
architecture behavior of activation_funct is
type reg_type is array(0 to 255) of sfixed(7 downto -24);
signal mem: reg_type :=(
            "00000000100000000000000000000000",	--0.0000//addr: 0
            "00000000100000111111111110101011",
            "00000000100001111111110101010110",
            "00000000100010111111011100001000",
            "00000000100011111110101011001101",
            "00000000100100111101011010111100",
            "00000000100101111011100100000000",
            "00000000100110111000111111010000",
            "00000000100111110101100101111111",
            "00000000101000110001010001110011",
            "00000000101001101011111100110001",
            "00000000101010100101100001011001",
            "00000000101011011101111010101000",
            "00000000101100010101000011111100",
            "00000000101101001010111001010100",
            "00000000101101111111010111001101",
      --end at 0.93750"
            "00000000101110110010011010101000",	--1.0000
            "00000000101111100100000001000010",
            "00000000110000010100001000011100",
            "00000000110001000010101111010010",
            "00000000110001101111110100100000",
            "00000000110010011011010111011100",
            "00000000110011000101010111111000",
            "00000000110011101101110101111110",
            "00000000110100010100110010010000",
            "00000000110100111010001101100010",
            "00000000110101011110001001000000",
            "00000000110110000000100110000010",
            "00000000110110100001100110010100",
            "00000000110111000001001011101100",
            "00000000110111011111011000001110",
            "00000000110111111100001110000111",
    --end at 1.93750"
            "00000000111000010111101111101011",	--2.0000
            "00000000111000110001111111010111",
            "00000000111001001010111111101101",
            "00000000111001100010110011010010",
            "00000000111001111001011100101101",
            "00000000111010001110111110101010",
            "00000000111010100011011011110011",
            "00000000111010110110110110110001",
            "00000000111011001001010010001111",
            "00000000111011011010110000110011",
            "00000000111011101011010101000011",
            "00000000111011111011000001100000",
            "00000000111100001001111000101001",
            "00000000111100010111111100111010",
            "00000000111100100101010000101001",
            "00000000111100110001110110001000",
--end at 2.93750"
            "00000000111100111101101111100110",	--3.0000
            "00000000111101001000111111001011",
            "00000000111101010011100110111101",
            "00000000111101011101101000111011",
            "00000000111101100111000110111111",
            "00000000111101110000000010111111",
            "00000000111101111000011110101101",
            "00000000111110000000011011110101",
            "00000000111110000111111011111110",
            "00000000111110001111000000101100",
            "00000000111110010101101011011100",
            "00000000111110011011111101101001",
            "00000000111110100001111000101000",
            "00000000111110100111011101101011",
            "00000000111110101100101110000000",
            "00000000111110110001101010110000",
--end at 3.93750"
            "00000000111110110110010101000001",	--4.0000
            "00000000111110111010101101110111",
            "00000000111110111110110110001111",
            "00000000111111000010101111000110",
            "00000000111111000110011001010011",
            "00000000111111001001110101101110",
            "00000000111111001101000101001000",
            "00000000111111010000001000010000",
            "00000000111111010010111111110110",
            "00000000111111010101101100100010",
            "00000000111111011000001110111111",
            "00000000111111011010100111110001",
            "00000000111111011100110111011110",
            "00000000111111011100110111011110",
            "00000000111111100000111101101011",
            "00000000111111100010110101001010",
--end at 4.93750"
            "00000000111111100100100101100001",	--5.0000
            "00000000111111100110001111001001",
            "00000000111111100111110010011101",
            "00000000111111101001001111110100",
            "00000000111111101010100111100101",
            "00000000111111101011111010000101",
            "00000000111111101101000111101000",
            "00000000111111101110010000100001",
            "00000000111111101111010101000010",
            "00000000111111110000010101011100",
            "00000000111111110001010001111101",
            "00000000111111110010001010110110",
            "00000000111111110011000000010011",
            "00000000111111110011110010100011",
            "00000000111111110100100001110000",
            "00000000111111110101001110001000",
--end at 5.93750"
            "00000000111111110101110111110100",	--6.0000
            "00000000111111110110011111000000",
            "00000000111111110111000011110100",
            "00000000111111110111100110011010",
            "00000000111111111000000110111011",
            "00000000111111111000100101011110",
            "00000000111111111001000010001011",
            "00000000111111111001011101001001",
            "00000000111111111001110110011110",
            "00000000111111111010001110010010",
            "00000000111111111010100100101010",
            "00000000111111111010111001101011",
            "00000000111111111011001101011011",
            "00000000111111111011011111111110",
            "00000000111111111011110001011010",
            "00000000111111111100000001110010",
--end at 6.93750"
            "00000000111111111100010001001011",	--7.0000
            "00000000111111111100011111101000",
            "00000000111111111100101101001110",
            "00000000111111111100111001111110",
            "00000000111111111101000101111110",
            "00000000111111111101010001001111",
            "00000000111111111101011011110100",
            "00000000111111111101100101110000",
            "00000000111111111101101111000110",
            "00000000111111111101110111111000",
            "00000000111111111110000000000111",
            "00000000111111111110000111110111",
            "00000000111111111110001111001000",
            "00000000111111111110010101111110",
            "00000000111111111110011100011001",
            "00000000111111111110100010011011",--addr: 127
--end at 7.93750

            "00000000000000000001010111111010",	-- -8.0000 addr: 128
            "00000000000000000001011101100101",
            "00000000000000000001100011100111",
            "00000000000000000001101010000010",
            "00000000000000000001110000111000",
            "00000000000000000001111000001001",
            "00000000000000000001111111111001",
            "00000000000000000010001000001000",
            "00000000000000000010010000111010",
            "00000000000000000010011010010000",
            "00000000000000000010100100001100",
            "00000000000000000010101110110001",
            "00000000000000000010111010000010",
            "00000000000000000011000110000010",
            "00000000000000000011010010110010",
            "00000000000000000011100000011000",
--end at -7.06250
            "00000000000000000011101110110101",	-- -7.0000
            "00000000000000000011111110001110",
            "00000000000000000100001110100110",
            "00000000000000000100100000000010",
            "00000000000000000100110010100101",
            "00000000000000000101000110010101",
            "00000000000000000101011011010110",
            "00000000000000000101110001100010",
            "00000000000000000110001001100010",
            "00000000000000000110100010110111",
            "00000000000000000110111101110101",
            "00000000000000000111011010100010",
            "00000000000000000111111001000101",
            "00000000000000001000011001100110",
            "00000000000000001000111100001100",
            "00000000000000001001100001000000",
--end at -6.06250
            "00000000000000001010001000001100",	-- -6.0000
            "00000000000000001010110001111000",
            "00000000000000001011011110010000",
            "00000000000000001100001101011101",
            "00000000000000001100111111101101",
            "00000000000000001101110101001010",
            "00000000000000001110101110000011",
            "00000000000000001111101010100100",
            "00000000000000010000101010111110",
            "00000000000000010001101111011111",
            "00000000000000010010111000011000",
            "00000000000000010100000101111011",
            "00000000000000010101011000011011",
            "00000000000000010110110000001100",
            "00000000000000011000001101100011",
            "00000000000000011001110000110111",
--end at -5.06250
            "00000000000000011011011010011111",	-- -5.0000
            "00000000000000011101001010110110",
            "00000000000000011111000010010101",
            "00000000000000100001000001011010",
            "00000000000000100011001000100010",
            "00000000000000100101011000001111",
            "00000000000000100111110001000001",
            "00000000000000101010010011011110",
            "00000000000000101101000000001010",
            "00000000000000101111110111110000",
            "00000000000000110010111010111000",
            "00000000000000110110001010010010",
            "00000000000000111001100110101101",
            "00000000000000111101010000111010",
            "00000000000001000001001001110001",
            "00000000000001000101010010001001",
--end at -4.06250
            "00000000000001001001101010111111",	-- -4.0000
            "00000000000001001110010101010000",
            "00000000000001010011010010000000",
            "00000000000001011000100010010101",
            "00000000000001011110000111011000",
            "00000000000001100100000010010111",
            "00000000000001101010010100100100",
            "00000000000001110000111111010100",
            "00000000000001111000000100000010",
            "00000000000001111111100100000011",
            "00000000000010000111100001000011",
            "00000000000010001111111101000001",
            "00000000000010011000111001000001",
            "00000000000010100010010111000101",
            "00000000000010101100011001000011",
            "00000000000010110111000000110101",
--end at -3.06250
            "00000000000011000010010000011010",	-- -3.0000
            "00000000000011001110001001111000",
            "00000000000011011010101111010111",
            "00000000000011101000000011000110",
            "00000000000011110110000111010111",
            "00000000000100000100111110100000",
            "00000000000100010100101010111101",
            "00000000000100100101001111001101",
            "00000000000100110110101101110001",
            "00000000000101001001001001001111",
            "00000000000101011100100100001101",
            "00000000000101110001000001010110",
            "00000000000110000110100011010011",
            "00000000000110011101001100101110",
            "00000000000110110101000000010011",
            "00000000000111001110000000101001",
--end at -2.06250
            "00000000000111101000010000010101",	-- -2.0000
            "00000000001000000011110001111001",
            "00000000001000100000100111110010",
            "00000000001000111110110100010100",
            "00000000001001011110011001101100",
            "00000000001001111111011001111110",
            "00000000001010100001110111000000",
            "00000000001011000101110010011110",
            "00000000001011101011001101110000",
            "00000000001100010010001010000010",
            "00000000001100111010101000001000",
            "00000000001101100100101000100100",
            "00000000001110010000001011100000",
            "00000000001110111101010000101110",
            "00000000001111101011110111100100",
            "00000000010000011011111110111110",
--end at -1.06250"
            "00000000010001001101100101011000",	-- -1.0000
            "00000000010010000000101000110011",
            "00000000010010110101000110101100",
            "00000000010011101010111100000100",
            "00000000010100100010000101011000",
            "00000000010101011010011110100111",
            "00000000010110010100000011001111",
            "00000000010111001110101110001101",
            "00000000011000001010011010000001",
            "00000000011001000111000000110000",
            "00000000011010000100011100000000",
            "00000000011011000010100101000100",
            "00000000011100000001010100110011",
            "00000000011101000000100011111000",
            "00000000011110000000001010101010",
            "00000000011111000000000001010101") ;--addr: 255
  --end at -0.06250"
begin
    process(clk)
        subtype address_t is std_logic_vector(i_weighted_input'length - 1 downto 0);
        variable address : address_t;
    begin
          if(areset = '1') then
              o_activation_funct <= (others => '0');
          elsif rising_edge(clk) then
            address := address_t(i_weighted_input);

                o_activation_funct <=
              mem(to_integer(unsigned(address)))(activation_int_w - 1 downto
                 -activation_fract_w);
          end if;
	end process;
end behavior;

configuration config1 of activation_funct is
    for funct 
    end for;
end config1;
