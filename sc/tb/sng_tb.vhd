-------------------------------------------------------------------------------
-- Title      : Testbench for design "sng"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sng_tb.vhd
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
USE std.env.ALL;
use work.sc_tb_pkg.all;

-------------------------------------------------------------------------------

ENTITY sng_tb IS

END ENTITY sng_tb;

-------------------------------------------------------------------------------

ARCHITECTURE test OF sng_tb IS

  -- component generics
  CONSTANT DATA_WIDTH : INTEGER   := 6;
  CONSTANT CLK_PERIOD : TIME      := 10 NS;
  -- component ports
  SIGNAL clk          : STD_LOGIC := '1';
  SIGNAL rst_n        : STD_LOGIC := '0';
  SIGNAL set_seed_in  : STD_LOGIC;
  SIGNAL seed_in      : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL enable_in    : STD_LOGIC;
  SIGNAL px_in        : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL sc_out       : STD_LOGIC;

  SIGNAL counter : UNSIGNED(DATA_WIDTH-1 DOWNTO 0);

BEGIN  -- ARCHITECTURE test

  -- component instantiation
  DUT : ENTITY work.sng
    GENERIC MAP (
      DATA_WIDTH => DATA_WIDTH)
    PORT MAP (
      clk         => clk,
      rst_n       => rst_n,
      set_seed_in => set_seed_in,
      seed_in     => seed_in,
      enable_in   => enable_in,
      px_in       => px_in,
      sc_out      => sc_out);

  -- clock generation
  Clk   <= NOT Clk AFTER CLK_PERIOD/2;
  rst_n <= '1'     AFTER 3*CLK_PERIOD + CLK_PERIOD/8;
  -- waveform generation
  WaveGen_Proc : PROCESS
  BEGIN
    -- insert signal assignments here
    set_seed_in <= '0';
    enable_in   <= '0';

    -- 1/4 represented in 8-bit data
    WAIT UNTIL rst_n = '1';
    set_seed_in <= '1';
    seed_in     <= STD_LOGIC_VECTOR(to_unsigned(5, seed_in'LENGTH));
    WAIT UNTIL Clk = '1';
    WAIT FOR CLK_PERIOD/8;
    set_seed_in <= '0';

    for i in 0 to 2**DATA_WIDTH - 1 loop
        enable_in   <= '1';
        px_in       <= STD_LOGIC_VECTOR(to_unsigned(i, px_in'LENGTH));

        FOR i IN 0 TO 2**DATA_WIDTH - 2 LOOP
          WAIT UNTIL clk = '1';
        END LOOP;  -- i

        enable_in <= '0';
        WAIT FOR CLK_PERIOD / 2;
        ASSERT counter = UNSIGNED(px_in)
            REPORT "Error or Data correlated" SEVERITY ERROR;
        WAIT FOR 3*CLK_PERIOD;
    end loop;
    finish(2);
  END PROCESS WaveGen_Proc;

  convert_proc: PROCESS (clk, rst_n) IS
  BEGIN  -- PROCESS convert_proc
    IF rst_n = '0'THEN                 -- asynchronous reset (active low)
      counter <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN         -- rising clock edge
        IF enable_in = '1' THEN
            IF sc_out = '1' THEN
                counter <= counter + 1;
            END IF;
        ELSE
            counter <= (OTHERS => '0');
        END IF;
    END IF;
  END PROCESS convert_proc;

END ARCHITECTURE test;

-------------------------------------------------------------------------------

CONFIGURATION sng_tb_test_cfg OF sng_tb IS
  FOR test
  END FOR;
END sng_tb_test_cfg;

-------------------------------------------------------------------------------
