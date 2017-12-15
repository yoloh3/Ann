-------------------------------------------------------------------------------
-- Title      : Stochastic Number Generator
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sng.vhd
-- Author     : Hieu D. Bui  <Hieu D. Bui@>
-- Company    : SISLAB, VNU-UET
-- Created    : 2017-12-15
-- Last update: 2017-12-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Generate a Stochastic number by using a linear feedback register
-------------------------------------------------------------------------------
-- Copyright (c) 2017 SISLAB, VNU-UET
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2017-12-15  1.0      Hieu D. Bui     Created
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sng IS

  GENERIC (
    DATA_WIDTH : INTEGER := 8);

  PORT (
    clk         : IN  STD_LOGIC;
    rst_n       : IN  STD_LOGIC;
    set_seed_in : IN  STD_LOGIC;
    enable_in   : IN  STD_LOGIC;
    seed_in     : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    px_in       : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    sc_out      : OUT STD_LOGIC);

END ENTITY sng;

ARCHITECTURE beh OF sng IS
  COMPONENT lfsr IS
    GENERIC (
      DATA_WIDTH : INTEGER);
    PORT (
      clk         : IN  STD_LOGIC;
      rst_n       : IN  STD_LOGIC;
      seed_in     : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
      set_seed_in : IN  STD_LOGIC;
      enable_in   : IN  STD_LOGIC;
      lfsr_out    : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0));
  END COMPONENT lfsr;

  -- random number generator output
  SIGNAL rng_var : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

BEGIN  -- ARCHITECTURE beh

  rng_1 : ENTITY work.lfsr
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      seed_in     => seed_in,
      set_seed_in => set_seed_in,
      enable_in   => enable_in,
      lfsr_out    => rng_var);

  -- number of bit '1' devided by DATA_WIDTH in sc_out
  -- represents the probability px_in
  -- for example, the following series represent 1/4
  -- 01010000
  sc_out <= '1' WHEN UNSIGNED(rng_var) < UNSIGNED(px_in) ELSE '0';
END ARCHITECTURE beh;
