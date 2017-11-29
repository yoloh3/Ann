---------------------------------------------------------------------------------
--
-- Copyright (c) 2018 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : NN_dadz.vhd
-- @Author          : Nguyen Van-Dung  @Modifier           :
-- @Created Date    : 15 Nov 2017    @Modified Date      :
-- @Project         : Neural Network
-- @Module          : NN_dadz
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
entity dadz is
  generic(
    INTEGER_WIDTH : integer := 8;
    FLOAT_WIDTH   : integer := 24
);
  port(
    clk    : in std_logic;
    areset : in std_logic;
    i_a    : in  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
    o_dadz : out  sfixed(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH)
  );
end dadz;

---------------------------------------------------------------------------------
-- Architecture description
---------------------------------------------------------------------------------
architecture rtl_dadz of dadz is
signal tmp_dadz : sfixed(INTEGER_WIDTH*2 - 1 downto -(FLOAT_WIDTH*2));
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
  dadz: process(clk, areset)
  begin
    if areset = '1' then
      tmp_dadz <= (others => '0');
    elsif rising_edge(clk) then
      tmp_dadz <= (to_sfixed(1,tmp_dadz) - i_a)*i_a;
    end if;
    o_dadz <= tmp_dadz(INTEGER_WIDTH - 1 downto -FLOAT_WIDTH);
  end process;
end rtl_dadz;

