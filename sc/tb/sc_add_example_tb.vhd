-------------------------------------------------------------------------------
-- Title      : Testbench for design "sc_add_example"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sc_add_example_tb.vhd
-- Author     : Hieu D. Bui  <Hieu D. Bui@>
-- Company    : SISLAB, VNU-UET
-- Created    : 2017-12-16
-- Last update: 2017-12-17
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

ENTITY sc_add_example_tb IS

END ENTITY sc_add_example_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF sc_add_example_tb IS

  -- component generics
  CONSTANT DATA_WIDTH : INTEGER := 10;
  CONSTANT SC_VARS    : INTEGER := 3; -- don't change this

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
  SIGNAL add_valid_out : STD_LOGIC;
  SIGNAL add_out       : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

BEGIN  -- ARCHITECTURE test

  -- component instantiation
  DUT : ENTITY work.sc_add_example
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH,
      SC_VARS    => SC_VARS)
    PORT MAP (
      clk           => clk,
      rst_n         => rst_n,
      start_in      => start_in,
      seed_in       => seed_in,
      pxs_in        => pxs_in,
      add_valid_out => add_valid_out,
      add_out       => add_out);

  -- clock generation
  clk   <= NOT Clk AFTER CLK_PERIOD/2;
  rst_n <= '1'     AFTER 3*CLK_PERIOD + CLK_PERIOD/2;

  -- waveform generation
  WaveGen_Proc : PROCESS
    VARIABLE seed1    : POSITIVE := 10;
    VARIABLE seed2    : POSITIVE := 2000;
    VARIABLE rand_val : REAL     := 0.0;

    PROCEDURE test_sc (
      CONSTANT pxs : IN darray_t)
    IS
      CONSTANT max_val : REAL := REAL(2**DATA_WIDTH);
      VARIABLE pxs_v   : sarray_t;
      VARIABLE sum : REAL := 0.0;
    BEGIN
      FOR i IN 0 TO SC_VARS-1 LOOP
        pxs_v(i) := real_to_stdlv(pxs(i), DATA_WIDTH);
        print(STRING'("Conversion ERROR: ")
              & REAL'IMAGE(real_to_stdlv_error(pxs(i), DATA_WIDTH)));
        pxs_in(DATA_WIDTH*(i+1)-1 DOWNTO DATA_WIDTH*i) <= pxs_v(i);
      END LOOP;  -- i
      sum := (pxs(0) + pxs(1))/2.0;
      start_in <= '1';
      WAIT UNTIL rising_edge(clk);
      WAIT FOR CLK_PERIOD/2;
      start_in <= '0';

      WAIT UNTIL add_valid_out = '1';
      print(STRING'("Result ERROR: ")
            & real'IMAGE(sum-stdlv_to_real(add_out)));
      WAIT UNTIL rising_edge(clk);
      WAIT FOR CLK_PERIOD/8;
    END PROCEDURE;
  BEGIN
    -- insert signal assignments here
    start_in <= '0';
    seed_in  <= (OTHERS => '0');
    pxs_in   <= (OTHERS => '0');
    WAIT UNTIL rst_n = '1';
    -- uniform(seed1, seed2, rand_val);
    -- seed_in  <= real_to_stdlv(rand_val, seed_in'LENGTH);
    seed_in <= real_to_stdlv(0.5, seed_in'LENGTH);
    test_sc((0.5, 0.5, 0.5));
    test_sc((0.3, 0.3, 0.5));
    test_sc((0.1, 0.2, 0.5));
    test_sc((0.8, 0.8, 0.5));
    test_sc((0.8, 0.3, 0.5));
    WAIT UNTIL rising_edge(clk);

    finish(2);
  END PROCESS WaveGen_Proc;



END ARCHITECTURE test;

-------------------------------------------------------------------------------

CONFIGURATION sc_add_example_tb_test_cfg OF sc_add_example_tb IS
  FOR test
  END FOR;
END sc_add_example_tb_test_cfg;

-------------------------------------------------------------------------------
