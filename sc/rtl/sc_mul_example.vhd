-------------------------------------------------------------------------------
-- Title      : Stochastic MUltiply example
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sc_mul_example.vhd
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
USE ieee.math_real.ALL;

ENTITY sc_mul_example IS

  GENERIC (
    DATA_WIDTH : INTEGER := 8);

  PORT (
    clk           : IN  STD_LOGIC;
    rst_n         : IN  STD_LOGIC;
    start_in      : IN  STD_LOGIC;
    seed1_in      : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    seed2_in      : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    px1_in        : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    px2_in        : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    mul_valid_out : OUT STD_LOGIC;
    mul_out       : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0));

END ENTITY sc_mul_example;

ARCHITECTURE beh OF sc_mul_example IS
--  SIGNAL set_seed   : STD_LOGIC;
  SIGNAL enable     : STD_LOGIC;
  SIGNAL sc_counter : UNSIGNED(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL px1        : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL px2        : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL sc_stream  : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL result_counter : UNSIGNED(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL result         : STD_LOGIC;

  type counter_t is array(integer range <>) of UNSIGNED(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL counter :  counter_t(1 downto 0);
BEGIN  -- ARCHITECTURE beh

  sc_counter_proc : PROCESS (clk, rst_n) IS
  BEGIN  -- PROCESS sc_counter_proc
    IF rst_n = '0' THEN                 -- asynchronous reset (active low)
      sc_counter     <= (OTHERS => '0');
      enable         <= '0';
      mul_valid_out  <= '0';
      px1            <= (OTHERS => '0');
      px2            <= (OTHERS => '0');
      result_counter <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN         -- rising clock edge
      IF start_in = '1' THEN
        px1           <= px1_in;
        px2           <= px2_in;
        sc_counter    <= (OTHERS => '0');
        result_counter <= (OTHERS => '0');
        enable        <= '1';
        mul_valid_out <= '0';
      END IF;

      IF enable = '1' THEN
        sc_counter <= sc_counter + 1;
      END IF;

      IF sc_counter = to_unsigned((2**DATA_WIDTH) - 2, sc_counter'LENGTH) THEN
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

  sng_1 : ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed1_in,
      px_in       => px1,
      sc_out      => sc_stream(0));

  sng_2 : ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed2_in,
      px_in       => px2,
      sc_out      => sc_stream(1));

  -- Stochastic multiplication in unipolar domain
  result  <= sc_stream(0) AND sc_stream(1);
  mul_out <= STD_LOGIC_VECTOR(result_counter);

  count: PROCESS (clk, rst_n) IS
  BEGIN  -- PROCESS convert_proc
    IF rst_n = '0'THEN
        counter <= (others => (OTHERS => '0'));
    ELSIF rising_edge(clk) THEN         -- rising clock edge
        IF enable = '1' THEN
            IF sc_stream(0) = '1' THEN
                counter(0) <= counter(0) + 1;
            END IF;
            IF sc_stream(1) = '1' THEN
                counter(1) <= counter(1) + 1;
            END IF;
        ELSE
            counter <= (others => (OTHERS => '0'));
        END IF;
    END IF;
  END PROCESS count;
END ARCHITECTURE beh;
