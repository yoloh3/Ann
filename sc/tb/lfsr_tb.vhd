-------------------------------------------------------------------------------
-- Title      : Testbench for design "lfsr"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : lfsr_tb.vhd
-- Author     : Hieu D. Bui  <Hieu D. Bui@>
-- Company    : SISLAB, VNU-UET
-- Created    : 2017-12-14
-- Last update: 2017-12-14
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2017 SISLAB, VNU-UET
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2017-12-14  1.0      Hieu D. Bui     Created
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE std.env.ALL;
-------------------------------------------------------------------------------

ENTITY lfsr_tb IS

END ENTITY lfsr_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF lfsr_tb IS

  -- component generics
  CONSTANT DATA_WIDTH : INTEGER   := 168;
  CONSTANT CLK_PERIOD : TIME      := 10 NS;
  -- component ports
  SIGNAL clk          : STD_LOGIC := '1';
  SIGNAL rst_n        : STD_LOGIC := '0';
  SIGNAL seed_in      : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL set_seed_in  : STD_LOGIC;
  SIGNAL enable_in    : STD_LOGIC;
  SIGNAL lfsr_out     : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

BEGIN  -- ARCHITECTURE test

  -- component instantiation
  DUT : ENTITY work.lfsr
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      seed_in     => seed_in,
      set_seed_in => set_seed_in,
      enable_in   => enable_in,
      lfsr_out    => lfsr_out);

  -- clock & reset generation
  clk   <= NOT Clk AFTER CLK_PERIOD/2;
  rst_n <= '1'     AFTER 3*CLK_PERIOD + CLK_PERIOD/8;

  -- waveform generation
  WaveGen_Proc : PROCESS
  BEGIN
    -- insert signal assignments here
    seed_in     <= (OTHERS => '0');
    enable_in   <= '0';
    set_seed_in <= '0';
    WAIT UNTIL rst_n = '1';
    seed_in     <= STD_LOGIC_VECTOR(to_unsigned(5, seed_in'LENGTH));
    set_seed_in <= '1';
    WAIT UNTIL clk = '1';
    WAIT FOR CLK_PERIOD/8;
    set_seed_in <= '0';
    enable_in   <= '1';
    WAIT UNTIL Clk = '1';
    FOR i IN 0 TO 15 LOOP
      WAIT UNTIL clk = '1';
    END LOOP;  -- i
    finish(2);
  END PROCESS WaveGen_Proc;


END ARCHITECTURE test;

-------------------------------------------------------------------------------

CONFIGURATION lfsr_tb_test_cfg OF lfsr_tb IS
  FOR test
  END FOR;
END lfsr_tb_test_cfg;

-------------------------------------------------------------------------------
