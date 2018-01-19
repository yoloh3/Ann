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

ENTITY sc_add_tff IS

  GENERIC (
    DATA_WIDTH : INTEGER := 8;          -- variable data width
    SC_VARS    : INTEGER := 3);         -- only support 2 variable

  PORT (
    clk           : IN  STD_LOGIC;
    rst_n         : IN  STD_LOGIC;
    start_in      : IN  STD_LOGIC;
    seed_in       : IN  STD_LOGIC_VECTOR(DATA_WIDTH * SC_VARS-1 DOWNTO 0);
    pxs_in        : IN  STD_LOGIC_VECTOR(DATA_WIDTH * SC_VARS-1 DOWNTO 0);
    add_valid_out : OUT STD_LOGIC;
    add_out       : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0));

END ENTITY sc_add_tff;

ARCHITECTURE beh OF sc_add_tff IS

  TYPE darray_t IS ARRAY (0 TO SC_VARS-1)
    OF STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL pxs  : darray_t;
  SIGNAL rngs : darray_t;
  SIGNAL lfsr : STD_LOGIC_VECTOR(DATA_WIDTH * SC_VARS - 1 DOWNTO 0);

  SIGNAL enable     : STD_LOGIC;
  SIGNAL control    : STD_LOGIC;
  SIGNAL q_tff      : STD_LOGIC;
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
      add_valid_out  <= '0';
      pxs            <= (OTHERS => (OTHERS => '0'));
      result_counter <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN         -- rising clock edge
      IF start_in = '1' THEN
        FOR i IN 0 TO SC_VARS-1 LOOP
          pxs(i) <= pxs_in(DATA_WIDTH*(i+1)-1 DOWNTO i*DATA_WIDTH);
        END LOOP;  -- i 
        sc_counter     <= (OTHERS => '0');
        result_counter <= (OTHERS => '0');
        enable         <= '1';
        add_valid_out  <= '0';
      END IF;

      IF enable = '1' THEN
        sc_counter <= sc_counter + 1;
      END IF;

      IF AND(sc_counter) THEN
        enable        <= '0';
        add_valid_out <= '1';
      ELSE
        add_valid_out <= '0';
      END IF;

      IF enable = '1' AND result = '1' THEN
        result_counter <= result_counter + 1;
      END IF;
    END IF;
  END PROCESS sc_counter_proc;

  lfsr_1 : ENTITY work.lfsr
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH * SC_VARS)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      seed_in     => seed_in,
      set_seed_in => start_in,
      enable_in   => enable,
      lfsr_out    => lfsr);

  rngs_gen : FOR i IN 0 TO SC_VARS - 1 GENERATE
    rngs(i)      <= lfsr(DATA_WIDTH * (i+1) - 1 DOWNTO DATA_WIDTH*i);
    sc_stream(i) <= '1' WHEN UNSIGNED(rngs(i)) < UNSIGNED(pxs(i)) ELSE '0';
  END GENERATE rngs_gen;

  -- Stochastic multiplication in unipolar domain
  control  <= sc_stream(2); 

  tff: PROCESS (clk, rst_n) IS
  BEGIN  -- PROCESS sc_counter_proc
    IF rst_n = '0' THEN                 -- asynchronous reset (active low)
        q_tff <= '0';
    ELSIF rising_edge(clk) THEN         -- rising clock edge
        q_tff <= control xor q_tff;
    END IF;
  END PROCESS tff;

  result  <= q_tff WHEN control = '1' ELSE sc_stream(1);
  add_out <= STD_LOGIC_VECTOR(result_counter);
END ARCHITECTURE beh;
