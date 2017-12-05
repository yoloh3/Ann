---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2017.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : activation_funct
-- @Author          : Xuan-Thuan Nguyen @Modifier      : Huy-Hung Ho
-- @Created Date    : 9 Nov 2017        @Modified Date : Nov 19 2017 08:35
-- @Project         : Neural Network
-- @Module          : activation_funct 
-- @Description     : 8 bits memory to store value of sigmoid calculation.
-- Input:
--  clk     : 1 bit
--  din     : 1 bit : read enable
--  addr    : 8 bits 00000000 : value of sigmoid func with input from -8.0 to 7.93750
-- Output:
--  dout    : 32 bits 0000_0000.0000_0000_0000_0000_0000_0000   : output value for sigmoid func.
-- Latency  : 1 clk
-- @Version : 0.1beta
-- @ID      : N/A
-- Modified : Edit from fixed value to using initiation function
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;

---------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------
entity activation_funct is
    port (
        clk                : in  std_logic;
        i_din              : in  std_logic;
        i_weighted_input   : in  weighted_input_float_t;
        o_activation_funct : out activation_float_t
    );
end activation_funct;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture mem_256k of activation_funct is
    constant addr_width : integer := 8;
    constant mem_depth  : integer := 2**addr_width;
    type mem_type is array(0 to mem_depth - 1) of activation_float_t;

    function init_mem return mem_type is
        variable temp_mem : mem_type;
    begin
        for i in 0 to mem_depth / 2 - 1 loop
            temp_mem(i) := to_sfixed(1.0 / (1.0 + exp(-(real(i)/16.0))),
                activation_int_w - 1, -activation_fract_w);
        end loop;
        for i in mem_depth / 2 to mem_depth - 1 loop
            temp_mem(i) := to_sfixed(1.0 / (1.0 + exp(-(real(i-mem_depth)/16.0))),
                activation_int_w - 1, -activation_fract_w);
        end loop;
        return temp_mem;
    end function;

    signal mem: mem_type := init_mem;
begin
    process(clk)
    begin
      if rising_edge(clk) then
              if(i_din = '1') then
                  o_activation_funct <= mem(to_integer(i_weighted_input));
              else
                  o_activation_funct <= (others => 'Z');
              end if;
          end if;
    end process;
end mem_256k;
