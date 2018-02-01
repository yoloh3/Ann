-------------------------------------------------------------------------------
-- Title      : Stochastic MUltiply example
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sc_weighted_in_hidden.vhd
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

ENTITY sc_weighted_in_hidden IS

  GENERIC (
    DATA_WIDTH : INTEGER := 8
  );

  PORT (
    clk           : IN  STD_LOGIC;
    rst_n         : IN  STD_LOGIC;
    start_in      : IN  STD_LOGIC;
    input1        : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    input2        : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    weight1       : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    weight2       : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    bias          : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    valid_out     : OUT STD_LOGIC;
    result_out    : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
 );

END ENTITY sc_weighted_in_hidden;

ARCHITECTURE beh OF sc_weighted_in_hidden IS
  SIGNAL sc_input1, sc_input2         : STD_LOGIC;
  SIGNAL sc_weight1, sc_weight2       : STD_LOGIC;
  SIGNAL sc_bias                      : STD_LOGIC;
  SIGNAL sc_mul1, sc_mul2             : STD_LOGIC;
  SIGNAL sc_add1, sc_add2             : STD_LOGIC;
  SIGNAL sc_ctrl1, sc_ctrl2, sc_ctrl3 : STD_LOGIC;
  SIGNAL q_tff1, q_tff2, q_tff3       : STD_LOGIC;
  SIGNAL sc_zero                      : STD_LOGIC;

  SIGNAL enable          : STD_LOGIC;
  SIGNAL sc_counter      : UNSIGNED(DATA_WIDTH-1 DOWNTO 0);

  SIGNAL result_counter  : UNSIGNED(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL result          : STD_LOGIC;

  constant SNG_NUM       : integer := 6;
  type SEED_IN_T is array(integer range <>)
    of STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

  function init_seed_in return SEED_IN_T is
    type RAND_SEED_INT_T is array(integer range <>) of integer; 
    constant rand_seed_int : RAND_SEED_INT_T(0 to SNG_NUM - 1)
        := (123, 19, 154, 198, 13, 2**DATA_WIDTH/2);

    variable seed_in_tmp: SEED_IN_T(0 to SNG_NUM - 1);
  begin
    for i in 0 to SNG_NUM - 1 loop
        seed_in_tmp(i) := STD_LOGIC_VECTOR(to_unsigned(rand_seed_int(i), DATA_WIDTH));
    end loop;
    return seed_in_tmp;
  end function init_seed_in;

  SIGNAL seed_in : SEED_IN_T(0 to SNG_NUM - 1) := init_seed_in;

  type counter_t is array(integer range <>) of UNSIGNED(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL counter   :  counter_t(0 to SNG_NUM - 1);
  SIGNAL count_out :  counter_t(0 to SNG_NUM - 1);
BEGIN  -- ARCHITECTURE beh

  sc_counter_proc : PROCESS (clk, rst_n) IS
  BEGIN  -- PROCESS sc_counter_proc
    IF rst_n = '0' THEN                 -- asynchronous reset (active low)
      sc_counter     <= (OTHERS => '0');
      enable         <= '0';
      valid_out      <= '0';
      result_counter <= (OTHERS => '0');

    ELSIF rising_edge(clk) THEN         -- rising clock edge
            IF start_in = '1' THEN
        sc_counter    <= (OTHERS => '0');
        result_counter <= (OTHERS => '0');
        enable        <= '1';
        valid_out     <= '0';
      END IF;

      IF enable = '1' THEN
        sc_counter <= sc_counter + 1;
      END IF;

      IF sc_counter = to_unsigned((2**DATA_WIDTH) - 1, sc_counter'LENGTH) THEN
        enable        <= '0';
        valid_out <= '1';
      ELSE
        valid_out <= '0';
      END IF;

      IF enable = '1' AND result = '1' THEN
        result_counter <= result_counter + 1;
      END IF;
    END IF;
  END PROCESS sc_counter_proc;

  input_1 : ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(0),
      px_in       => input1,
      sc_out      => sc_input1);

  input_2 : ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(1),
      px_in       => input2,
      sc_out      => sc_input2);

  weight_1: ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(2),
      px_in       => weight1,
      sc_out      => sc_weight1);

  weight_sng: ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(3),
      px_in       => weight2,
      sc_out      => sc_weight2);

  bias_sng: ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(4),
      px_in       => bias,
      sc_out      => sc_bias);

  haft_one: ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(5),
      px_in       => bias,
      sc_out      => sc_zero);

  -- Stochastic multiplication in bipolar domain
  sc_mul1 <= sc_input1 xnor sc_weight1;
  sc_mul2 <= sc_input2 xnor sc_weight2;

  sc_ctrl1 <= sc_mul1 XOR sc_mul2;
  sc_ctrl2 <= sc_ctrl1;
  sc_ctrl3 <= sc_add1 XOR sc_add2;

  tff: PROCESS (clk, rst_n) IS
  BEGIN  -- PROCESS sc_counter_proc
    IF rst_n = '0' THEN                 -- asynchronous reset (active low)
        q_tff1 <= '0';
        q_tff2 <= '0';
        q_tff3 <= '0';
    ELSIF rising_edge(clk) THEN         -- rising clock edge
        q_tff1 <= sc_ctrl1 xor q_tff1;
        q_tff2 <= sc_ctrl2 xor q_tff2;
        q_tff3 <= sc_ctrl3 xor q_tff3;
    END IF;
  END PROCESS tff;

  sc_add1 <= q_tff1 when sc_ctrl1 = '1' else sc_mul1;
  sc_add2 <= q_tff2 when sc_ctrl2 = '1' else sc_bias;
  result   <= q_tff3 when sc_ctrl3 = '1' else sc_add2;
  result_out <= STD_LOGIC_VECTOR(result_counter);

  count: PROCESS (clk, rst_n) IS
  BEGIN  -- PROCESS convert_proc
    IF rst_n = '0'THEN
        counter <= (others => (OTHERS => '0'));
        count_out <= (others => (OTHERS => '0'));
    ELSIF rising_edge(clk) THEN         -- rising clock edge
        IF enable = '1' THEN
            IF sc_input1 = '1' THEN
                counter(0) <= counter(0) + 1;
            END IF;
            IF sc_input2 = '1' THEN
                counter(1) <= counter(1) + 1;
            END IF;
            IF sc_weight1 = '1' THEN
                counter(2) <= counter(2) + 1;
            END IF;
            IF sc_weight2 = '1' THEN
                counter(3) <= counter(3) + 1;
            END IF;
            IF sc_bias = '1' THEN
                counter(4) <= counter(4) + 1;
            END IF;

            IF sc_mul1 = '1' THEN
                count_out(0) <= count_out(0) + 1;
            END IF;
            IF sc_mul2 = '1' THEN
                count_out(1) <= count_out(1) + 1;
            END IF;
            IF sc_add1 = '1' THEN
                count_out(2) <= count_out(2) + 1;
            END IF;
            IF sc_add2 = '1' THEN
                count_out(3) <= count_out(3) + 1;
            END IF;
        ELSE
            counter <= (others => (OTHERS => '0'));
            count_out <= (others => (OTHERS => '0'));
        END IF;
    END IF;
  END PROCESS count;
END ARCHITECTURE beh;
