---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : sc_weighted_in_output_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Feb 05 2018       @Modified Date : Feb 05 2018 14:01
-- @Project         : Artificial Neural Network
-- @Module          : sc_weighted_in_output_tb
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE std.env.ALL;
USE std.textio.ALL;
USE work.sc_tb_pkg.ALL;

-------------------------------------------------------------------------------

ENTITY sc_weighted_in_output_tb IS

END ENTITY sc_weighted_in_output_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF sc_weighted_in_output_tb IS

  -- component generics
  CONSTANT DATA_WIDTH  : INTEGER   := 8;
  CONSTANT CLK_PERIOD  : TIME      := 10 NS;

  -- component ports
  SIGNAL start_in   : STD_LOGIC;
  SIGNAL input1     : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL input2     : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL input3     : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL weight1    : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL weight2    : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL weight3    : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL bias       : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL valid_out  : STD_LOGIC;
  SIGNAL result_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

  SIGNAL clk        : STD_LOGIC := '1';
  SIGNAL rst_n      : STD_LOGIC := '0';
  SIGNAL mse_error  : REAL; 

BEGIN  -- ARCHITECTURE test

  -- component instantiation
  DUT: ENTITY work.sc_weighted_in_output
    generic map (
        DATA_WIDTH => DATA_WIDTH                      
    )
    port map (
        clk        => clk,
        rst_n      => rst_n,
        start_in   => start_in,
        input1     => input1,
        input2     => input2,
        input3     => input3,
        weight1    => weight1,
        weight2    => weight2,
        weight3    => weight3,
        bias       => bias,
        valid_out  => valid_out,
        result_out => result_out                  
    );

  -- clock generation
  clk   <= NOT clk AFTER CLK_PERIOD/2;
  rst_n <= '1'     AFTER 3*CLK_PERIOD + CLK_PERIOD/8;

  -- waveform generation
  WaveGen_Proc : PROCESS
    PROCEDURE test_sc (
      CONSTANT i1   : IN REAL;
      CONSTANT i2   : IN REAL;
      CONSTANT i3   : IN REAL;
      CONSTANT w1   : IN REAL;
      CONSTANT w2   : IN REAL;
      CONSTANT w3   : IN REAL;
      CONSTANT b    : IN REAL)
    IS
      VARIABLE result_expected : REAL;
    BEGIN
      ASSERT
            i1 >= -1.0 AND i1 <= 1.0
        AND i2 >= -1.0 AND i2 <= 1.0
        AND i3 >= -1.0 AND i3 <= 1.0
        AND w1 >= -1.0 AND w1 <= 1.0
        AND w2 >= -1.0 AND w2 <= 1.0
        AND w3 >= -1.0 AND w3 <= 1.0
        AND b  >= -1.0 AND b  <= 1.0
            REPORT "Invalid inputs" SEVERITY ERROR;

      result_expected := (i1 * w1 + i2 * w2 + i3 * w3 + b) / 4.0;

      input1   <= real_to_stdlv((i1+1.0) / 2.0, input1'LENGTH);
      input2   <= real_to_stdlv((i2+1.0) / 2.0, input2'LENGTH);
      input3   <= real_to_stdlv((i3+1.0) / 2.0, input3'LENGTH);
      weight1  <= real_to_stdlv((w1+1.0) / 2.0, weight1'LENGTH);
      weight2  <= real_to_stdlv((w2+1.0) / 2.0, weight2'LENGTH);
      weight3  <= real_to_stdlv((w3+1.0) / 2.0, weight3'LENGTH);
      bias     <= real_to_stdlv((b +1.0) / 2.0, bias'LENGTH);

      start_in <= '1';
      WAIT UNTIL rising_edge(clk);
      WAIT FOR CLK_PERIOD/8;
      start_in <= '0';
      WAIT UNTIL valid_out = '1';

      mse_error <= mse_error
                     + mse(result_expected, stdlv_to_real(result_out) * 2.0 - 1.0);
      print(real'image(result_expected) & string'(" ")
        & real'image(stdlv_to_real(result_out) * 2.0 - 1.0));

      WAIT UNTIL rising_edge(clk);
    END PROCEDURE test_sc;

    variable counter: integer;
  BEGIN
    -- insert signal assignments here
    start_in   <= '0';
    input1     <= (OTHERS => '0');
    input2     <= (OTHERS => '0');
    input3     <= (OTHERS => '0');
    weight1    <= (OTHERS => '0');
    weight2    <= (OTHERS => '0');
    weight3    <= (OTHERS => '0');
    bias       <= (OTHERS => '0');
    mse_error  <= 0.0;
    counter    := 0;

    WAIT UNTIL rst_n = '1';

    test_sc(0.1, 0.0, 0.0, 0.1, 0.0, 0.3, 0.99);
    test_sc(0.1, -0.960, 0.240, 0.19, 0.32, 0.3, 0.99);
    test_sc(0.41, -0.15, 0.90, 0.4, -0.84, 0.21, -0.39);
    test_sc(0.9, -0.9, 0.90, 0.9, -0.9, 0.9, -0.9);
    test_sc(0.9, 0.9, 0.90, 0.9, 0.9, 0.9, 0.9);


    WAIT FOR 3*CLK_PERIOD;
    print(STRING'("MSE = ")
        -- & real'image(mse_error / real(counter)));
        & real'image(mse_error / 5.0));

    finish(2);
  END PROCESS WaveGen_Proc;

END ARCHITECTURE test;

-------------------------------------------------------------------------------

CONFIGURATION sc_weighted_in_output_tb_test_cfg OF sc_weighted_in_output_tb IS
  FOR test
  END FOR;
END sc_weighted_in_output_tb_test_cfg;

-------------------------------------------------------------------------------
