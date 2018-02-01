------------------------------------------------------------------------------
-- Title      : Stochastic Computing Testbench package for vhdl
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sc_tb_pkg.vhd
-- Author     : Hieu D. Bui  <Hieu D. Bui@>
-- Company    : SISLAB, VNU-UET
-- Created    : 2017-12-16
-- Last update: 2017-12-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2017 SISLAB, VNU-UET
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2017-12-16  1.0      Hieu D. Bui     Created
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE std.textio.ALL;

PACKAGE sc_tb_pkg IS

  FUNCTION real_to_stdlv (
    CONSTANT real_val : REAL;
    CONSTANT size     : INTEGER)
    RETURN STD_LOGIC_VECTOR;

  FUNCTION stdlv_to_real (
    CONSTANT stdlv : STD_LOGIC_VECTOR)
    RETURN REAL;

  FUNCTION real_to_stdlv_error (
    CONSTANT real_val : REAL;
    CONSTANT size     : INTEGER)
    RETURN REAL;
  PROCEDURE print (
    CONSTANT str : IN STRING);


  FUNCTION real_sign_to_stdlv (
    CONSTANT real_val : REAL;
    CONSTANT size     : INTEGER)
    RETURN STD_LOGIC_VECTOR;

 FUNCTION stdlv_sign_to_real (
    CONSTANT stdlv : STD_LOGIC_VECTOR)
    RETURN REAL;

 FUNCTION is_real_equal(expected, actual, error_rate: real) return boolean;

 FUNCTION error_percent(expected, actual: real) return real;

 FUNCTION mse(expected, actual: real) return real;
END PACKAGE sc_tb_pkg;



PACKAGE BODY sc_tb_pkg IS

  FUNCTION real_to_stdlv (
    CONSTANT real_val : REAL;
    CONSTANT size     : INTEGER)
    RETURN STD_LOGIC_VECTOR IS
    VARIABLE max_val : REAL;
  BEGIN  -- FUNCTION real_to_stdlv
    max_val := REAL(2**size);
    RETURN STD_LOGIC_VECTOR(to_unsigned(INTEGER(real_val*max_val), size));
  END FUNCTION real_to_stdlv;

  FUNCTION real_sign_to_stdlv (
    CONSTANT real_val : REAL;
    CONSTANT size     : INTEGER)
    RETURN STD_LOGIC_VECTOR IS
    VARIABLE max_val : REAL;
  BEGIN  -- FUNCTION real_sign_to_stdlv
    max_val := REAL(2**size / 2);
    RETURN STD_LOGIC_VECTOR(to_signed(INTEGER(real_val*max_val), size));
  END FUNCTION real_sign_to_stdlv;


  FUNCTION stdlv_to_real (
    CONSTANT stdlv : STD_LOGIC_VECTOR)
    RETURN REAL
  IS
  BEGIN
    RETURN REAL(to_integer(UNSIGNED(stdlv))) / REAL(2**stdlv'LENGTH);
  END FUNCTION stdlv_to_real;

  FUNCTION stdlv_sign_to_real (
    CONSTANT stdlv : STD_LOGIC_VECTOR)
    RETURN REAL
  IS
  BEGIN
    RETURN REAL(to_integer(SIGNED(stdlv))) / REAL(2**stdlv'LENGTH / 2);
  END FUNCTION stdlv_sign_to_real;

  PROCEDURE print (
    CONSTANT str : IN STRING)
  IS
    VARIABLE msg : LINE;
  BEGIN
    write(msg, str);
    writeline(output, msg);
  END PROCEDURE;

  FUNCTION real_to_stdlv_error (
    CONSTANT real_val : REAL;
    CONSTANT size     : INTEGER)
    RETURN REAL IS
    VARIABLE stdlv_val     : STD_LOGIC_VECTOR(size-1 DOWNTO 0);
    VARIABLE max_val       : REAL;
    VARIABLE error_val     : REAL;
    VARIABLE converted_val : REAL;
    VARIABLE l             : LINE;
  BEGIN
    max_val       := REAL(2**size);
    stdlv_val     := real_to_stdlv(real_val, size);
    converted_val := REAL(to_integer(UNSIGNED(stdlv_val)))/max_val;
    error_val     := real_val - converted_val;
    RETURN error_val;
  END FUNCTION real_to_stdlv_error;

  function is_real_equal(expected, actual, error_rate: real) return boolean is
  begin
      if expected = actual then
          return true;
      else
          return abs(expected - actual) < 10.0 ** error_rate;
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
      if expected = actual or abs(expected - actual) < 1.0e-8 then
          return 0.0;
      else
          return (expected - actual)**2;
      end if;
  end mse;
END PACKAGE BODY sc_tb_pkg;
