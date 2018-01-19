-------------------------------------------------------------------------------
-- Title      : Testbench for design "sc_mul"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sc_mul_tb.vhd
-- Author     : Hieu D. Bui  <Hieu D. Bui@>
-- Company    : SISLAB, VNU-UET
-- Created    : 2017-12-16
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
-- 2017-12-16  1.0      Hieu D. Bui     Created
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE std.env.ALL;
USE std.textio.ALL;
USE work.sc_tb_pkg.ALL;
-------------------------------------------------------------------------------

ENTITY sc_mul_tb IS

END ENTITY sc_mul_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF sc_mul_tb IS

  -- component generics
  CONSTANT DATA_WIDTH : INTEGER := 16;
  CONSTANT SC_VARS    : INTEGER := 2;

  CONSTANT CLK_PERIOD : TIME := 10 NS;

  TYPE darray_t IS ARRAY (0 TO SC_VARS-1) OF REAL;
  TYPE sarray_t IS ARRAY (0 TO SC_VARS-1)
    OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  -- component ports
  SIGNAL clk           : STD_LOGIC := '1';
  SIGNAL rst_n         : STD_LOGIC := '0';
  SIGNAL start_in      : STD_LOGIC;
  SIGNAL seed_in       : STD_LOGIC_VECTOR(DATA_WIDTH * SC_VARS-1 DOWNTO 0);
  SIGNAL pxs_in        : STD_LOGIC_VECTOR(DATA_WIDTH * SC_VARS-1 DOWNTO 0);
  SIGNAL mul_valid_out : STD_LOGIC;
  SIGNAL mul_out       : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL mse_error     : real;

BEGIN  -- ARCHITECTURE test

  -- component instantiation
  DUT : ENTITY work.sc_mul
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH,
      SC_VARS    => SC_VARS)
    PORT MAP (
      clk           => clk,
      rst_n         => rst_n,
      start_in      => start_in,
      seed_in       => seed_in,
      pxs_in        => pxs_in,
      mul_valid_out => mul_valid_out,
      mul_out       => mul_out);

  -- clock generation
  clk   <= NOT Clk AFTER CLK_PERIOD/2;
  rst_n <= '1'     AFTER 3*CLK_PERIOD + CLK_PERIOD/2;

  -- waveform generation
  WaveGen_Proc : PROCESS
    PROCEDURE test_sc (
      CONSTANT pxs : IN darray_t)
    IS
      VARIABLE pxs_v   : sarray_t;
      VARIABLE mul_expected : REAL := 1.0;
    BEGIN
      FOR i IN 0 TO SC_VARS-1 LOOP
        ASSERT pxs(i) >= 0.0 AND pxs(i)     <= 1.0
            REPORT "Invalid inputs" SEVERITY ERROR;

        mul_expected  := mul_expected * pxs(i);
        pxs_v(i) := real_to_stdlv(pxs(i), DATA_WIDTH);
        pxs_in(DATA_WIDTH*(i+1)-1 DOWNTO DATA_WIDTH*i) <= pxs_v(i);
      END LOOP;  -- i

      seed_in <= STD_LOGIC_VECTOR(to_unsigned(45428, seed_in'LENGTH));

      start_in <= '1';
      WAIT UNTIL rising_edge(clk);
      WAIT FOR CLK_PERIOD/2;
      start_in <= '0';
      WAIT UNTIL mul_valid_out = '1';

      mse_error <= mse_error
                 + mse(mul_expected, stdlv_to_real(mul_out));
      print(real'image(mse(mul_expected, stdlv_to_real(mul_out))));

      WAIT UNTIL rising_edge(clk);
      WAIT FOR CLK_PERIOD/8;
    END PROCEDURE;
  BEGIN
    -- insert signal assignments here
    start_in  <= '0';
    seed_in   <= (OTHERS => '0');
    pxs_in    <= (OTHERS => '0');
    mse_error <= 1.0e-8;
    WAIT UNTIL rst_n = '1';

    test_sc((0.5, 0.5));
    test_sc((0.8, 0.3));
    test_sc((0.7, 0.4));

    -- for i in 1 to 2**DATA_WIDTH - 1 loop
        -- for j in 1 to 2**DATA_WIDTH - 1 loop
            -- test_sc((real(i) / 2.0**DATA_WIDTH, real(j) / 2.0**DATA_WIDTH));
        -- end loop;
    -- end loop;

    WAIT FOR 3*CLK_PERIOD;
    print(STRING'("MSE = ")
        & real'image(mse_error /5.0));
        -- & real'image(mse_error / real(2**(DATA_WIDTH*2))));


    finish(2);
  END PROCESS WaveGen_Proc;


END ARCHITECTURE test;

-------------------------------------------------------------------------------

CONFIGURATION sc_mul_tb_test_cfg OF sc_mul_tb IS
  FOR test
  END FOR;
END sc_mul_tb_test_cfg;

-------------------------------------------------------------------------------
