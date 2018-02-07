---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : sc_weighted_in_output.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Feb 05 2018       @Modified Date : Feb 05 2018 12:00
-- @Project         : Artificial Neural Network
-- @Module          : sc_weighted_in_output
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY sc_weighted_in_output IS

  GENERIC (
    DATA_WIDTH : INTEGER := 8
  );

  PORT (
    clk           : IN  STD_LOGIC;
    rst_n         : IN  STD_LOGIC;
    start_in      : IN  STD_LOGIC;
    input1        : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    input2        : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    input3        : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    weight1       : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    weight2       : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    weight3       : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    bias          : IN  STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    valid_out     : OUT STD_LOGIC;
    result_out    : OUT STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0)
 );

END ENTITY sc_weighted_in_output;

ARCHITECTURE beh OF sc_weighted_in_output IS
  SIGNAL sc_input1, sc_input2, sc_input3    : STD_LOGIC;
  SIGNAL sc_weight1, sc_weight2, sc_weight3 : STD_LOGIC;
  SIGNAL sc_bias                            : STD_LOGIC;
  SIGNAL sc_mul1, sc_mul2, sc_mul3          : STD_LOGIC;
  SIGNAL sc_add1, sc_add2, sc_add3          : STD_LOGIC;
  SIGNAL sc_ctrl1, sc_ctrl2, sc_ctrl3       : STD_LOGIC;
  SIGNAL q_tff1, q_tff2, q_tff3             : STD_LOGIC;
  SIGNAL sc_haft_one                        : STD_LOGIC;

  SIGNAL enable          : STD_LOGIC;
  SIGNAL sc_counter      : UNSIGNED(DATA_WIDTH-1 DOWNTO 0);

  SIGNAL result_counter  : UNSIGNED(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL result          : STD_LOGIC;

  constant SNG_NUM       : integer := 8;
  type SEED_IN_T is array(integer range <>)
    of STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

  function init_seed_in return SEED_IN_T is
    type RAND_SEED_INT_T is array(integer range <>) of integer; 
    constant rand_seed_int : RAND_SEED_INT_T(0 to SNG_NUM - 1)
        := (123, 19, 154, 98, 177, 24, 23, 2**DATA_WIDTH/2);

    variable seed_in_tmp: SEED_IN_T(0 to SNG_NUM - 1);
  begin
    for i in 0 to SNG_NUM - 1 loop
        seed_in_tmp(i) := STD_LOGIC_VECTOR(to_unsigned(rand_seed_int(i), DATA_WIDTH));
    end loop;
    return seed_in_tmp;
  end function init_seed_in;

  SIGNAL seed_in : SEED_IN_T(0 to SNG_NUM - 1) := init_seed_in;

  type counter_t is array(integer range <>) of UNSIGNED(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL counter   :  counter_t(0 to 6);
  SIGNAL count_out :  counter_t(0 to 5);
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

  input_3 : ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(2),
      px_in       => input3,
      sc_out      => sc_input3);

  weight_1: ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(3),
      px_in       => weight1,
      sc_out      => sc_weight1);

  weight_2: ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(4),
      px_in       => weight2,
      sc_out      => sc_weight2);

  weight_3: ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(5),
      px_in       => weight3,
      sc_out      => sc_weight3);

  bias_sng: ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => start_in,
      enable_in   => enable,
      seed_in     => seed_in(6),
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
      seed_in     => seed_in(7),
      px_in       => bias,
      sc_out      => sc_haft_one);

  -- Stochastic multiplication in bipolar domain
  sc_mul1 <= sc_input1 xnor sc_weight1;
  sc_mul2 <= sc_input2 xnor sc_weight2;
  sc_mul3 <= sc_input3 xnor sc_weight3;

  sc_ctrl1 <= sc_mul1 XOR sc_mul2;
  sc_ctrl2 <= sc_mul3 XOR sc_bias;
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
  sc_add2 <= q_tff2 when sc_ctrl2 = '1' else sc_mul3;
  result  <= q_tff3 when sc_ctrl3 = '1' else sc_add1;
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
            IF sc_input3 = '1' THEN
                counter(2) <= counter(2) + 1;
            END IF;
            IF sc_weight1 = '1' THEN
                counter(3) <= counter(3) + 1;
            END IF;
            IF sc_weight2 = '1' THEN
                counter(4) <= counter(4) + 1;
            END IF;
            IF sc_weight3 = '1' THEN
                counter(5) <= counter(5) + 1;
            END IF;
            IF sc_bias = '1' THEN
                counter(6) <= counter(6) + 1;
            END IF;

            IF sc_mul1 = '1' THEN
                count_out(0) <= count_out(0) + 1;
            END IF;
            IF sc_mul2 = '1' THEN
                count_out(1) <= count_out(1) + 1;
            END IF;
            IF sc_mul3 = '1' THEN
                count_out(2) <= count_out(2) + 1;
            END IF;
            IF sc_add1 = '1' THEN
                count_out(3) <= count_out(3) + 1;
            END IF;
            IF sc_add2 = '1' THEN
                count_out(4) <= count_out(4) + 1;
            END IF;
            IF result = '1' THEN
                count_out(5) <= count_out(5) + 1;
            END IF;
        ELSE
            counter <= (others => (OTHERS => '0'));
            count_out <= (others => (OTHERS => '0'));
        END IF;
    END IF;
  END PROCESS count;
END ARCHITECTURE beh;
