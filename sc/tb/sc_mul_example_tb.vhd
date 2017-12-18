-------------------------------------------------------------------------------
-- Title      : Testbench for design "sc_mul_example"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sc_mul_example_tb.vhd
-- Author     : Hieu D. Bui  <Hieu D. Bui@>
-- Company    : SISLAB, VNU-UET
-- Created    : 2017-12-15
-- Last update: 2017-12-18
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
USE ieee.math_real.ALL;
USE std.env.ALL;
USE std.textio.ALL;
USE work.sc_tb_pkg.ALL;

-------------------------------------------------------------------------------

ENTITY sc_mul_example_tb IS

END ENTITY sc_mul_example_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF sc_mul_example_tb IS

  -- component generics
  CONSTANT DATA_WIDTH  : INTEGER   := 8;
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
  clk   <= NOT clk AFTER CLK_PERIOD/2;
  rst_n <= '1'     AFTER 3*CLK_PERIOD + CLK_PERIOD/8;
  -- waveform generation
  WaveGen_Proc : PROCESS
    PROCEDURE test_sc (
      CONSTANT px1 : IN REAL;
      CONSTANT px2 : IN REAL)
    IS
      VARIABLE px1_int      : INTEGER;
      VARIABLE px2_int      : INTEGER;
      VARIABLE px1_real     : REAL;
      VARIABLE px2_real     : REAL;
      VARIABLE mul_expected : REAL;
      VARIABLE mul_real     : REAL;
      VARIABLE max_val      : REAL := REAL(2**DATA_WIDTH);
    BEGIN
      ASSERT
        px1 >= 0.0 AND px1     <= 1.0
        AND px2 >= 0.0 AND px2 <= 1.0
        REPORT "Invalid inputs" SEVERITY ERROR;
      mul_expected := px1*px2;

      px1_in   <= real_to_stdlv(px1, px1_in'LENGTH);
      seed1_in <= STD_LOGIC_VECTOR(to_unsigned(11, seed1_in'LENGTH));
      seed2_in <= STD_LOGIC_VECTOR(to_unsigned(7, seed2_in'LENGTH));
      px2_in   <= real_to_stdlv(px2, px2_in'LENGTH);
      start_in <= '1';

      print(STRING'("Input: px1 = ") & REAL'IMAGE(px1));
      print(STRING'("Input: px2 = ") & REAL'IMAGE(px2));
      print(STRING'("Converted input: px1 = ")
            & INTEGER'IMAGE(to_integer(UNSIGNED(px1_in))));
      print(STRING'("Converted input: px2 = ")
            & INTEGER'IMAGE(to_integer(UNSIGNED(px2_in))));
      print(STRING'("Conversion ERROR: px1 = ")
            & REAL'IMAGE(real_to_stdlv_error(px1, px1_in'LENGTH)));
      print(STRING'("Conversion ERROR: px2 = ")
            & REAL'IMAGE(real_to_stdlv_error(px2, px2_in'LENGTH)));

      WAIT UNTIL rising_edge(clk);
      WAIT FOR CLK_PERIOD/8;
      start_in <= '0';
      WAIT UNTIL mul_valid_out = '1';

      print(STRING'("Result: px1*px2 = ")
            & REAL'IMAGE(stdlv_to_real(mul_out)));
      print(STRING'("Result Error: ")
            & REAL'IMAGE(mul_expected - stdlv_to_real(mul_out)));

      WAIT UNTIL rising_edge(clk);
    END PROCEDURE test_sc;
  BEGIN
    -- insert signal assignments here
    start_in <= '0';
    seed1_in <= (OTHERS => '0');
    seed2_in <= (OTHERS => '0');
    px1_in   <= (OTHERS => '0');
    px2_in   <= (OTHERS => '0');
    WAIT UNTIL rst_n = '1';
    test_sc(0.5, 0.5);
    test_sc(0.3, 0.4);
    test_sc(0.9, 0.8);
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
