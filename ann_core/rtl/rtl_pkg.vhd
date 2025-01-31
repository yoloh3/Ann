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
use ieee.numeric_std.all;
use ieee.math_real.all;

---------------------------------------------------------------------------------
-- entity declaration
--------------------------------------------------------------------------------- 
package rtl_pkg is
    -- -- common
    constant layer_output_size      : integer := 2;
    constant layer_hidden_size      : integer := 3;
    constant layer_input_size       : integer := 2;
    constant weight_output_size     : integer := 2;
    constant epochs                 : integer := 10000;
    constant learning_rate          : real    := -0.2;

    -- -- forward package
    constant input_int_w            : integer := 6;
    constant input_fract_w          : integer := 10;
    subtype input_float_t
        is sfixed(input_int_w - 1 downto -input_fract_w);

    constant bias_int_w             : integer := 6;
    constant bias_fract_w           : integer := 10;
    subtype bias_float_t
        is sfixed(bias_int_w - 1 downto -bias_fract_w);

    constant weighted_input_int_w   : integer := 4;
    constant weighted_input_fract_w : integer := 4;
    subtype weighted_input_float_t
        is sfixed(weighted_input_int_w - 1 downto -weighted_input_fract_w);

    constant weight_int_w           : integer := 6;
    constant weight_fract_w         : integer := 10;
    subtype weight_float_t
        is sfixed(weight_int_w - 1 downto -weight_fract_w);

    constant activation_int_w       : integer := 6;
    constant activation_fract_w     : integer := 10;
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

    -- Origin parameters
    -- constant bias_init_hidden : bias_init_array_t(layer_hidden_size - 1 downto 0)
        -- := (others => -1.0);
        -- := (others => -1.0);
    -- constant weight_init_hidden : weight_init_input2hidden_array_t
        -- := (( 0.1, 0.6),
            -- (0.5, 0.3),
            -- (0.399414, 0.1));
    -- constant weight_init_output : weight_init_hidden2output_array_t
        -- := ((1.1, 0.5, 0.199921875),
            -- (1.3, 0.19921875, 0.69921875));

    -- Result of matlab simulation
    --constant bias_init_hidden : bias_init_array_t(layer_hidden_size - 1 downto 0)
    --    := ( -8.5522, 4.5047, -9.6504);
    --constant bias_init_output  : bias_init_array_t(layer_output_size - 1 downto 0)
    --    := (4.8426, -6.1217) ;
    --constant weight_init_hidden : weight_init_input2hidden_array_t
    --    := (( 5.7887, 5.9145),
    --        ( -2.9411, -3.1022),
    --        (6.7257, 6.5017));
    --constant weight_init_output : weight_init_hidden2output_array_t
    --    := ((-7.2093, 6.2029, -9.1909),
    --        (8.4980, -4.6304, 8.8234));

    -- Origin parameters
    constant bias_init_hidden : bias_init_array_t(layer_hidden_size - 1 downto 0)
        := (others => -2.0);
    constant bias_init_output : bias_init_array_t(layer_output_size - 1 downto 0)
        := (others => -1.2);
    constant weight_init_hidden : weight_init_input2hidden_array_t
        := (( 0.1, -0.26),
            (0.5, -3.3),
            (-0.49, 0.1));
    constant weight_init_output : weight_init_hidden2output_array_t
        := ((-1.1, 0.5, -0.8),
            (2.3, -5.3, 0.6));

    -- -- backward package

    -- derivative of activation (a'(z))
    constant dadz_int_w             : integer := 6;
    constant dadz_fract_w           : integer := 10;
    subtype  dadz_float_t
        is sfixed(dadz_int_w - 1 downto -dadz_fract_w);

    -- error layer (delta)
    constant error_int_w            : integer := 6;
    constant error_fract_w          : integer := 10;
    subtype  error_float_t
        is sfixed(error_int_w - 1 downto -error_fract_w);


    type error_array_t
        is array (integer range <>) of error_float_t;
    type dadz_array_t
        is array (integer range <>) of dadz_float_t;

    type weight_array2_hidden2input_t
        is array (layer_input_size - 1 downto 0)
            of weight_array_t(layer_hidden_size - 1 downto 0);
    type weight_array2_output2hidden_t
        is array (layer_hidden_size - 1 downto 0)
            of weight_array_t(layer_output_size - 1 downto 0);

    function sigmoid_funct (input: real) return real;
end rtl_pkg; 

---------------------------------------------------------------------------------
-- architecture description
---------------------------------------------------------------------------------
package body rtl_pkg is
    function sigmoid_funct (input: real) return real is
    begin
        return 1.0 / (1.0 + exp(-input));
    end function;
end rtl_pkg;

