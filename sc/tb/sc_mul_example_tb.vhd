-------------------------------------------------------------------------------
-- Title      : Testbench for design "sc_mul_example"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sc_mul_example_tb.vhd
-- Author     : Hieu D. Bui  <Hieu D. Bui@>
-- Company    : SISLAB, VNU-UET
-- Created    : 2017-12-15
-- Last update: 2017-12-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
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
USE std.env.ALL;

-------------------------------------------------------------------------------

ENTITY sc_mul_example_tb IS

END ENTITY sc_mul_example_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF sc_mul_example_tb IS

  -- component generics
  CONSTANT DATA_WIDTH  : INTEGER   := 4;
  CONSTANT CLK_PERIOD  : TIME      := 10 NS;
  -- component ports
  SIGNAL clk           : STD_LOGIC := '1';
  SIGNAL rst_n         : STD_LOGIC := '0';
  SIGNAL start_in      : STD_LOGIC;
  SIGNAL seed1_in      : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL seed2_in      : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL px1_in        : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL px2_in        : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL mul_valid_out : STD_LOGIC;
  SIGNAL mul_out       : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

BEGIN  -- ARCHITECTURE test

  -- component instantiation
  DUT : ENTITY work.sc_mul_example
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk           => clk,
      rst_n         => rst_n,
      start_in      => start_in,
      seed1_in      => seed1_in,
      seed2_in      => seed2_in,
      px1_in        => px1_in,
      px2_in        => px2_in,
      mul_valid_out => mul_valid_out,
      mul_out       => mul_out);

  -- clock generation
  Clk   <= NOT Clk AFTER CLK_PERIOD/2;
  rst_n <= '1'     AFTER 3*CLK_PERIOD + CLK_PERIOD/8;
  -- waveform generation
  WaveGen_Proc : PROCESS
  BEGIN
    -- insert signal assignments here
    start_in <= '0';
    seed1_in <= STD_LOGIC_VECTOR(to_unsigned(5,seed1_in'LENGTH));
    seed2_in <= STD_LOGIC_VECTOR(to_unsigned(7, seed2_in'LENGTH));
    px1_in <= STD_LOGIC_VECTOR(to_unsigned(4, px1_in'LENGTH)); -- 4/16
    px2_in <= STD_LOGIC_VECTOR(to_unsigned(4, px2_in'LENGTH)); -- 4/16
    WAIT UNTIL rst_n = '1';
    start_in <= '1';
    WAIT UNTIL Clk = '1';
    WAIT FOR CLK_PERIOD/8;
    start_in <= '0';

    WAIT UNTIL mul_valid_out = '1';
    ASSERT mul_out = STD_LOGIC_VECTOR(to_unsigned(1, mul_out'LENGTH)) REPORT "Test failed" SEVERITY ERROR;
    WAIT UNTIL rising_edge(clk);
    WAIT FOR CLK_PERIOD/8;
    start_in <= '1';
    px1_in <= STD_LOGIC_VECTOR(to_unsigned(4, px1_in'LENGTH)); -- 4/16
    px2_in <= STD_LOGIC_VECTOR(to_unsigned(7, px2_in'LENGTH)); -- 7/16
    WAIT UNTIL Clk = '1';
    WAIT FOR CLK_PERIOD/8;
    start_in <= '0';

    WAIT UNTIL mul_valid_out = '1';
    ASSERT mul_out = STD_LOGIC_VECTOR(to_unsigned(2, mul_out'LENGTH)) REPORT "Test failed" SEVERITY ERROR;
    WAIT UNTIL rising_edge(clk);
    WAIT FOR 3*CLK_PERIOD;

    finish(2);
  END PROCESS WaveGen_Proc;



END ARCHITECTURE test;

-------------------------------------------------------------------------------

CONFIGURATION sc_mul_example_tb_test_cfg OF sc_mul_example_tb IS
  FOR test
  END FOR;
END sc_mul_example_tb_test_cfg;

-------------------------------------------------------------------------------
