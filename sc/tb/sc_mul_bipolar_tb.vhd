-------------------------------------------------------------------------------
-- Title      : Testbench for design "sc_mul_bipolar"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sc_mul_bipolar_tb.vhd
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
use work.tb_pkg.all;

-------------------------------------------------------------------------------

ENTITY sc_mul_bipolar_tb IS

END ENTITY sc_mul_bipolar_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF sc_mul_bipolar_tb IS

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
  signal mse_error     : real;

BEGIN  -- ARCHITECTURE test

  -- component instantiation
  DUT : ENTITY work.sc_mul_bipolar
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
        px1 >= -1.0 AND px1     <= 1.0
        AND px2 >= -1.0 AND px2 <= 1.0
        REPORT "Invalid inputs" SEVERITY ERROR;
      mul_expected := px1*px2;

      seed1_in <= STD_LOGIC_VECTOR(to_unsigned(180, seed1_in'LENGTH));
      seed2_in <= STD_LOGIC_VECTOR(to_unsigned(75, seed2_in'LENGTH));
      px1_in   <= real_sign_to_stdlv(px1, px1_in'LENGTH);
      px2_in   <= real_sign_to_stdlv(px2, px2_in'LENGTH);
      start_in <= '1';

      WAIT UNTIL rising_edge(clk);
      WAIT FOR CLK_PERIOD/8;
      start_in <= '0';
      WAIT UNTIL mul_valid_out = '1';

   --    print(STRING'("ERROR = ")
   --    & REAL'IMAGE((0.001 + mul_expected - stdlv_to_real(mul_out))**2));
      print(real'image(mse_error));
      mse_error <= mse_error
                 + mse(mul_expected, stdlv_to_real(mul_out) * 2.0 - 1.0);

      WAIT UNTIL rising_edge(clk);
    END PROCEDURE test_sc;
  BEGIN
    -- insert signal assignments here
    start_in <= '0';
    seed1_in <= (OTHERS => '0');
    seed2_in <= (OTHERS => '0');
    px1_in   <= (OTHERS => '0');
    px2_in   <= (OTHERS => '0');
    mse_error <= 0.0001;
    WAIT UNTIL rst_n = '1';

    --test_sc(-0.5, -0.25);

    for i in -2**(DATA_WIDTH-1) to 2**(DATA_WIDTH - 1) - 1 loop
        for j in -2**(DATA_WIDTH-1) to 2**(DATA_WIDTH - 1) - 1 loop
            test_sc(real(i) / 2.0**DATA_WIDTH, real(j) / 2.0**DATA_WIDTH);
        end loop;
    end loop;

    WAIT FOR 3*CLK_PERIOD;
    print(STRING'("MSE = ")
        & real'image(mse_error / real(2**(DATA_WIDTH*2))));

    finish(2);
  END PROCESS WaveGen_Proc;



END ARCHITECTURE test;

-------------------------------------------------------------------------------

CONFIGURATION sc_mul_bipolar_tb_test_cfg OF sc_mul_bipolar_tb IS
  FOR test
  END FOR;
END sc_mul_bipolar_tb_test_cfg;

-------------------------------------------------------------------------------
