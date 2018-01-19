-------------------------------------------------------------------------------
-- Title      : Stochastic Multiplication
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sc_mul.vhd
-- Author     : Hieu D. Bui  <Hieu D. Bui@>
-- Company    : SISLAB, VNU-UET
-- Created    : 2017-12-16
-- Last update: 2017-12-16
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

ENTITY sc_mul IS

  GENERIC (
    DATA_WIDTH : INTEGER := 8;          -- variable data width
    SC_VARS    : INTEGER := 2);         -- number of sc variables

  PORT (
    clk           : IN  STD_LOGIC;
    rst_n         : IN  STD_LOGIC;
    start_in      : IN  STD_LOGIC;
    seed_in       : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    pxs_in        : IN  STD_LOGIC_VECTOR(DATA_WIDTH * SC_VARS-1 DOWNTO 0);
    mul_valid_out : OUT STD_LOGIC;
    mul_out       : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0));

END ENTITY sc_mul;

ARCHITECTURE beh OF sc_mul IS

  TYPE darray_t IS ARRAY (0 TO SC_VARS-1)
    OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL pxs        : darray_t;
  SIGNAL lfsr       : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL lfsr_buff  : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

  SIGNAL enable     : STD_LOGIC;
  SIGNAL sc_counter : UNSIGNED(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL sc_stream  : STD_LOGIC_VECTOR(SC_VARS-1 DOWNTO 0);

  SIGNAL result_counter : UNSIGNED(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL result         : STD_LOGIC;
BEGIN  -- ARCHITECTURE beh

  sc_counter_proc : PROCESS (clk, rst_n) IS
  BEGIN  -- PROCESS sc_counter_proc
    IF rst_n = '0' THEN                 -- asynchronous reset (active low)
      sc_counter     <= (OTHERS => '0');
      enable         <= '0';
      mul_valid_out  <= '0';
      pxs            <= (OTHERS => (OTHERS => '0'));
      result_counter <= (OTHERS => '0');
      lfsr_buff      <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN         -- rising clock edge

      lfsr_buff      <= lfsr_buff xnor lfsr;
      IF start_in = '1' THEN
        FOR i IN 0 TO SC_VARS-1 LOOP
          pxs(i) <= pxs_in(DATA_WIDTH*(i+1)-1 DOWNTO i*DATA_WIDTH);
        END LOOP;  -- i 

        enable         <= '1';
        sc_counter     <= (OTHERS => '0');
        result_counter <= (OTHERS => '0');
        mul_valid_out  <= '0';
      END IF;

      IF enable = '1' THEN
        sc_counter <= sc_counter + 1;
      END IF;

      IF sc_counter = to_unsigned(2**DATA_WIDTH - 2, sc_counter'length) THEN
        enable        <= '0';
        mul_valid_out <= '1';
      ELSE
        mul_valid_out <= '0';
      END IF;

      IF enable = '1' AND result = '1' THEN
        result_counter <= result_counter + 1;
      END IF;
    END IF;
  END PROCESS sc_counter_proc;

  lfsr_c: ENTITY work.lfsr
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      seed_in     => seed_in,
      set_seed_in => start_in,
      enable_in   => enable,
      lfsr_out    => lfsr
    );

  sc_stream(0) <= '1' WHEN UNSIGNED(lfsr) < UNSIGNED(pxs(0)) ELSE '0';
  sc_stream(1) <= '1' WHEN UNSIGNED(lfsr_buff) < UNSIGNED(pxs(0)) ELSE '0';

  -- Stochastic multiplication in unipolar domain
  result  <= sc_stream(0) AND sc_stream(1);
  mul_out <= STD_LOGIC_VECTOR(result_counter);
END ARCHITECTURE beh;
