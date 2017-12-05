---------------------------------------------------------------------------------
--
-- Copyright (c) 2017 by SISLAB Team, LSI Design Contest 2018.
-- The University of Engineering and Technology, Vietnam National University.
-- All right resevered.
--
-- Copyright notification
-- No part may be reproduced except as authorized by written permission.
-- 
-- @File            : rtl_pkg.vhd
-- @Author          : Huy-Hung Ho       @Modifier      : Huy-Hung Ho
-- @Created Date    : xim 30 2017       @Modified Date : xim 30 2017 10:08
-- @Project         : Artificial Neural Network
-- @Module          : rtl_pkg
-- @Description     :
-- @Version         :
-- @ID              :
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- library declaration
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.fixed_pkg.all;
use ieee.fixed_float_types.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------------
-- entity declaration
--------------------------------------------------------------------------------- 
package rtl_pkg is
    -- common
    constant layer_output_size      : integer := 2;
    constant layer_hidden_size      : integer := 3;
    constant layer_input_size       : integer := 2;
    constant weight_output_size      : integer := 2;

    -- forward package
    constant input_int_w            : integer := 8;
    constant input_fract_w          : integer := 24;
    subtype input_float_t
        is sfixed(input_int_w - 1 downto -input_fract_w);

    constant bias_int_w             : integer := 8;
    constant bias_fract_w           : integer := 24;
    subtype bias_float_t
        is sfixed(bias_int_w - 1 downto -bias_fract_w);

    constant weighted_input_int_w   : integer := 8;
    constant weighted_input_fract_w : integer := 24;
    subtype weighted_input_float_t
        is sfixed(weighted_input_int_w - 1 downto -weighted_input_fract_w);

    -- 4, 4
    constant weight_int_w           : integer := 8;
    constant weight_fract_w         : integer := 24;
    subtype weight_float_t
        is sfixed(weight_int_w - 1 downto -weight_fract_w);

    constant activation_int_w       : integer := 8;
    constant activation_fract_w     : integer := 24;
    subtype activation_float_t
        is sfixed(activation_int_w - 1 downto -activation_fract_w);


    type input_array_t
        is array (integer range <>) of input_float_t;
    type bias_array_t
        is array (integer range <>) of bias_float_t;
    type weighted_input_array_t
        is array (integer range <>) of weighted_input_float_t;
    type weight_array_t
        is array (integer range <>) of weight_float_t;

    type weight_array2_input2hidden_t
        is array (layer_hidden_size - 1 downto 0)
            of weight_array_t(layer_input_size - 1 downto 0);
    type weight_array2_hidden2output_t
        is array (layer_output_size - 1 downto 0)
            of weight_array_t(layer_hidden_size - 1 downto 0);
    type activation_array_t
        is array (integer range <>) of activation_float_t;

    type bias_init_array_t is array (integer range <>) of real;
    type weight_init_input2hidden_array_t is array (layer_hidden_size - 1 downto 0)
        of bias_init_array_t(layer_input_size - 1 downto 0);
    type weight_init_hidden2output_array_t is array (layer_output_size - 1 downto 0)
        of bias_init_array_t(layer_hidden_size - 1 downto 0);

    constant bias_init_hidden : bias_init_array_t(layer_hidden_size - 1 downto 0)
        := (others => -1.0);
    constant bias_init_output  : bias_init_array_t(layer_output_size - 1 downto 0)
        := (others => -1.0);
    constant weight_init_hidden : weight_init_input2hidden_array_t
        := (others => (others => -1.0));
    constant weight_init_output : weight_init_hidden2output_array_t
        := (others => (others => -1.0));

    -- backward package

    -- derivative of activation (a'(z))
    constant dadz_int_w             : integer := 8;
    constant dadz_fract_w           : integer := 24;
    subtype  dadz_float_t
        is sfixed(dadz_int_w - 1 downto -dadz_fract_w);

    -- error layer (delta)
    constant error_int_w            : integer := 8;
    constant error_fract_w          : integer := 24;
    subtype  error_float_t
        is sfixed(error_int_w - 1 downto -error_fract_w);


    type error_array_t
        is array (integer range <>) of error_float_t;
    type dadz_array_t
        is array (integer range <>) of dadz_float_t;
end rtl_pkg; 

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
package body rtl_pkg is
end rtl_pkg;

