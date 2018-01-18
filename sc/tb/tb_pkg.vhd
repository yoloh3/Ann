---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
--
-- @File            : tb_pkg.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : Nov 26 2017       @Modified Date : Nov 26 2017 20:10
-- @Project         : Artificial Neural Network
-- @Module          : tb_pkg
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
use ieee.numeric_std.all;
use ieee.math_real.all;

---------------------------------------------------------------------------------
-- entity declaration
---------------------------------------------------------------------------------
package tb_pkg is
    function is_real_equal(a, b, error_rate: real) return boolean;

    function error_percent(expected, actual: real) return real;

    function mse(expected, actual: real) return real;
end tb_pkg;

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
package body tb_pkg is
    function is_real_equal(a, b, error_rate: real) return boolean is
    begin
        if a = b then
            return true;
        else
            return abs(a - b) < 10.0 ** error_rate;
        end if;
    end function;

    function error_percent(expected, actual: real) return real is
    begin
        if expected = 0.0 then
            return 200.0;
        else
            return abs((expected - actual) / expected * 100.0);
        end if;
    end function;

    function mse(expected, actual: real) return real is
    begin
        if expected = actual or (expected - actual) < 1.0e-5 then
            return 0.0;
        else
            return (expected - actual)**2;
        end if;
    end mse;
end tb_pkg;
