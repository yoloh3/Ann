---------------------------------------------------------------------------------
--
-- Copyright (c) 2018 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_delta3.vhd
-- @Author          : Nguyen Van-Dung  @Modifier           :
-- @Created Date    : 15 Nov 2017    @Modified Date      :
-- @Project         : Neural Network
-- @Module          : NN_delta3
-- @Description     : Description of module.
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
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;

---------------------------------------------------------------------------------
-- Entity declaration
---------------------------------------------------------------------------------
entity delta3 is
  generic(
    INTEGER_WIDTH   : integer := 8;
    FLOAT_WIDTH     : integer := 24
);
  port(
    clk        : in  std_logic;
    areset     : in  std_logic;
    i_a3_i     : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    i_t_i      : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    i_dadz3_i  : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    o_delta3_i : out sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH)
  );
end delta3;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture rtl_delta3 of delta3 is
signal tmp_delta3_i : sfixed(INTEGER_WIDTH*2 - 1 downto -(FLOAT_WIDTH*2));
begin
  ---------------------------------------------------------------------------------
  -- Process Description
  -- @type:   Sequential process
  -- @brief:  Briefy Description
  -- @signals: - clock          : clk       <rising_edge active>
  --           - async. reset   : areset     <low active>
  --           - condition      : rising_edge(clk)
  --           - inputs/outputs : input: a,b, output: c
  ---------------------------------------------------------------------------------
  process(clk, areset)
  begin
    if areset = '1' then
      tmp_delta3_i <= (others => '0');
    elsif rising_edge(clk) then
      tmp_delta3_i <= (i_a3_i - i_t_i)*i_dadz3_i;
    end if;
  end process;
  o_delta3_i <= tmp_delta3_i(INTEGER_WIDTH - 1 downto -(FLOAT_WIDTH));
end rtl_delta3;

