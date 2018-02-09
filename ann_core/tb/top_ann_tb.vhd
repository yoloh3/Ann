---------------------------------------------------------------------------------
--
-- copyright (c) 2017 by sislab team, lsi design contest 2018.
-- the university of engineering and technology, vietnam national university.
-- all right resevered.
-- -- copyright notification -- no part may be reproduced except as authorized by written permission.
--
-- @file            : top_ann_tb.vhd
-- @author          : huy-hung ho       @modifier      : huy-hung ho
-- @created date    : kax 07 2017       @modified date : kax 07 2017 08:47
-- @project         : artificial neural network
-- @module          : top_ann_tb
-- @description     :
-- @version         :
-- @id              :
--
---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use work.rtl_pkg.all;
use work.tb_pkg.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use std.env.all;
use ieee.math_real.all;

---------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------
entity top_ann_tb is
end entity;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture bench of top_ann_tb is
    -- component declaration
    component top_ann
    port (
	    clk              : in std_logic;
        areset            : in std_logic;
        i_select_initial : in std_logic;
        i_update_coeff   : in std_logic;
        i_input          : in  input_array_t(layer_input_size - 1 downto 0);
        i_expected       : in  input_array_t(layer_input_size - 1 downto 0);
        o_finish_update  : out  std_logic;
        o_output_result  : out activation_array_t(layer_output_size - 1 downto 0)
    );
    end component top_ann;

    -- signal declaration
    signal s_i_select_initial : std_logic := '0';
    signal s_i_update_coeff   : std_logic := '0';
    signal s_i_input          : input_array_t(layer_input_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_i_expected       : input_array_t(layer_input_size - 1 downto 0)
        := (others => (others => '0'));
    signal s_o_finish_update  : std_logic;
    signal s_o_output_result  : activation_array_t(layer_output_size - 1 downto 0);
    signal s_clk              : std_logic := '0';
    signal s_areset           : std_logic := '1';
    constant period           : time := 100 ns;
begin
    -- device unit test
    dut: top_ann
    port map (
       clk               => s_clk,
       areset             => s_areset ,
       i_select_initial  => s_i_select_initial,
       i_update_coeff    => s_i_update_coeff,
       i_input           => s_i_input,
       i_expected        => s_i_expected,
       o_finish_update   => s_o_finish_update,
       o_output_result   => s_o_output_result  
    );

    s_clk <= not(s_clk) after period / 2;
    s_areset  <= '0'     after period;

    readio : process 
        variable iline        : line;
        variable oline        : line;
        variable aspace       : character;
        variable line_counter : integer := 0;

        -- notes: change below variable to std_logic_vector or std_logic
        type real_array_t is array (integer range <>) of real;
        variable v_i_input         : real_array_t(layer_input_size - 1 downto 0);
        variable v_i_expected      : real_array_t(layer_input_size - 1 downto 0);
        variable v_o_output_result : real_array_t(layer_output_size - 1 downto 0);

        file inf : text;
        file ouf : text;
<<<<<<< HEAD
        variable mse_error : real := 0.0;
=======
>>>>>>> git-svn

    begin
        file_open(ouf, "../tb/top_ann_result.txt",   write_mode);

        s_i_select_initial <= '1';
        s_i_update_coeff   <= '1';
        wait until s_areset  = '0';
        wait until rising_edge(s_clk);
        s_i_select_initial <= '0';
        mse_error := 0.0;

        for i in 0 to epochs - 1 loop
            file_open(inf, "../tb/top_ann_testcase.txt", read_mode);

            read_line: while not endfile(inf) loop
                line_counter := line_counter + 1;

                readline(inf,iline);
                for i in 0 to layer_input_size - 1 loop
                    read(iline, v_i_input(i));
                    read(iline, aspace);
                end loop;
                for i in 0 to layer_input_size - 1 loop
                    read(iline, v_i_expected(i));
                    read(iline, aspace);
                end loop;

                -- variable to signal
                for i in 0 to layer_input_size - 1 loop
                    s_i_input(i)    <= to_sfixed(v_i_input(i), input_int_w - 1, -input_fract_w);
                    s_i_expected(i) <= to_sfixed(v_i_expected(i), input_int_w - 1, -input_fract_w);
                end loop;

                -- wait for next input
                wait until rising_edge(s_clk);
                wait for 1 ns;
            end loop read_line;

            file_close(inf);
        end loop;

        file_close(ouf);
        finish(0);
    end process readio;

    check_output: process
        variable mse_error : real := 0.0;
    begin
        mse_error := 0.0;
        wait until s_o_finish_update = '1';

        -- Test case 1
        wait for period/8;
        print("At: " & time'image(now) &
            " a1 = " & real'image(to_real(s_o_output_result(0))) &
            " a2 = " & real'image(to_real(s_o_output_result(1))));
        mse_error := mse_error
                     + mse(1.0, to_real(s_o_output_result(0)))
                     + mse(0.0, to_real(s_o_output_result(1)));
        wait until rising_edge(s_clk);

        -- Test case 2
        wait for period/8;
        print("At: " & time'image(now) &
            " a1 = " & real'image(to_real(s_o_output_result(0))) &
            " a2 = " & real'image(to_real(s_o_output_result(1))));
        mse_error := mse_error
                     + mse(0.0, to_real(s_o_output_result(0)))
                     + mse(1.0, to_real(s_o_output_result(1)));
        wait until rising_edge(s_clk);

        -- Test case 3
        wait for period/8;
        print("At: " & time'image(now) &
            " a1 = " & real'image(to_real(s_o_output_result(0))) &
            " a2 = " & real'image(to_real(s_o_output_result(1))));
        mse_error := mse_error
                     + mse(0.0, to_real(s_o_output_result(0)))
                     + mse(1.0, to_real(s_o_output_result(1)));
        wait until rising_edge(s_clk);

        -- Test case 4
        wait for period/8;
        print("At: " & time'image(now) &
            " a1 = " & real'image(to_real(s_o_output_result(0))) &
            " a2 = " & real'image(to_real(s_o_output_result(1))));
        mse_error := mse_error
                     + mse(0.0, to_real(s_o_output_result(0)))
                     + mse(1.0, to_real(s_o_output_result(1)));
        wait until rising_edge(s_clk);

        -- Test case 5
        wait for period/8;
        print("At: " & time'image(now) &
            " a1 = " & real'image(to_real(s_o_output_result(0))) &
            " a2 = " & real'image(to_real(s_o_output_result(1))));
        mse_error := mse_error
                     + mse(1.0, to_real(s_o_output_result(0)))
                     + mse(0.0, to_real(s_o_output_result(1)));
        wait until rising_edge(s_clk);

        print("MSE = " & real'image(mse_error / 8.0));
    end process;

end bench;
