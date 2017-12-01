---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : sigmoid_tb.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Nov 26 2017       @Modified Date : Nov 26 2017 21:21
-- @Project         : Artificial Neural Network
-- @Module          : sigmoid_tb
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.fixed_float_types.all;
use ieee.numeric_std.all;
use work.config_pkg.compare_float;

---------------------------------------------------------------------------------
-- entity declaration
--------------------------------------------------------------------------------- 
entity sigmoid_tb is
end entity; 

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
architecture rtl of sigmoid_tb is
    component sigmoid_lut is
        generic (
            addr_width      : integer := 8;
            integer_width   : integer := 8;
            float_width     : integer := 24
        );
        port (
            clk    : in  std_logic;
            i_din  : in  std_logic;
            i_addr : in  unsigned(addr_width - 1 downto 0);
            o_dout : out sfixed(integer_width - 1 downto -float_width)
        );
    end component;

    constant addr_width    : integer := 8;
    constant integer_width : integer := 8;
    constant float_width   : integer := 24;
    signal clk             : std_logic := '0';
    signal i_din           : std_logic := '0';
    signal i_addr          : unsigned(addr_width - 1 downto 0) := (others => '0');
    signal o_dout          : sfixed(integer_width - 1 downto -float_width) := (others => '0');
    signal expected_o      : real := 0.0;
 
    constant period:         time := 100 ns;
begin
    uut: sigmoid_lut
        generic map (addr_width    => addr_width,
                     integer_width => integer_width,
                     float_width   => float_width) 
        port map (clk              => clk,
                  i_din            => i_din, 
                  i_addr           => i_addr, 
                  o_dout           => o_dout);

    clk <= not(clk) after period / 2;

    stimulus: process
    begin
        wait until rising_edge(clk);

        -- main simulation
        i_din <= '0';
        wait until rising_edge(clk); wait for 1 ns;
        expected_o <= 0.1;

        i_din  <= '1';
        i_addr <= to_unsigned(0, addr_width);
        wait until rising_edge(clk); wait for 1 ns;

        i_addr <= to_unsigned(1, addr_width);
        wait until rising_edge(clk); wait for 1 ns;

        i_addr <= to_unsigned(2, addr_width);
        wait until rising_edge(clk); wait for 1 ns;

        i_addr <= to_unsigned(128 + 5, addr_width);
        wait until rising_edge(clk); wait for 1 ns;

        wait;
    end process;

    print_i: process(i_addr)
        variable my_line : line;
    begin
        write(my_line, string'("   time "));
        write(my_line, time'image(now), right, 10);
        write(my_line, string'("i_addr: "), right, 10);
        write(my_line, real(to_integer(signed(i_addr))) / 16.0 );
        writeline(output, my_line);
    end process;

    print_o: process(o_dout)
        variable my_line : line;
    begin
        write(my_line, string'("   time "));
        write(my_line, time'image(now), right, 10);
        write(my_line, string'("o_dout: "), right, 10);
        write(my_line, to_real(o_dout));
        writeline(output, my_line); writeline(output, my_line);
    end process;

end rtl;

