---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : config_pkg.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : xim 23 2017       @Modified Date : xim 23 2017 11:29
-- @Project         : Artificial Neural Network
-- @Module          : config_pkg
-- @Description     : Some cofiguration for vhdl src
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

---------------------------------------------------------------------------------
-- Package declaration
--------------------------------------------------------------------------------- 
package config_pkg is
    function is_real_equal(a, b, epsilon : real) return boolean;
end config_pkg;

---------------------------------------------------------------------------------
-- Package description
---------------------------------------------------------------------------------
package body config_pkg is
    function is_real_equal(a, b, epsilon : real) return boolean is
    begin
        if a = b then
            return true;
        else
            return abs(a - b) < 10.0 ** epsilon;
        end if;
    end function;
end config_pkg;
