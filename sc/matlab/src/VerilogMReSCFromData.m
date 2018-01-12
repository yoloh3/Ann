%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (C) 2016 N. Eamon Gaffney
%%
%% This program is free software; you can resdistribute and/or modify it under
%% the terms of the MIT license, a copy of which should have been included with
%% this program at https://github.com/arminalaghi/scsynth
%%
%% References:
%% Qian, W., Li, X., Riedel, M. D., Bazargan, K., & Lilja, D. J. (2011). An
%% Architecture for Fault-Tolerant Computation with Stochastic Logic. IEEE
%% Transactions on Computers IEEE Trans. Comput., 60(1), 93-105.
%% doi:10.1109/tc.2010.202
%%
%% Qian, W., & Riedel, M.D.. (2010). The Synthesis of Stochastic Logic to
%% Perform Multivariate Polynomial Arithmetic.
%%
%% A. Alaghi and J. P. Hayes, "Exploiting correlation in stochastic circuit
%% design," 2013 IEEE 31st International Conference on Computer Design (ICCD),
%% Asheville, NC, 2013, pp. 39-46.
%% doi: 10.1109/ICCD.2013.6657023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function VerilogMReSCFromData (data, degrees, N, m_input, m_coeff,...
                               nameSuffix, ConstantRNG='SharedLFSR',...
                               InputRNG='LFSR')
  %Reconfigurable Architecture Based on Stochastic Logic, or ReSC, is a method
  %developed by Weikang Qian, Xin Li, Marc D. Riedel, Kia Bazargan, and David J.
  %Lilja for approximating the computation of any function with domain and range
  %in the unit interval as a stochastic circuit using a Bernstein polynomial
  %approximation of the function. The Multivariate form allows extension to
  %functions of several variables by using the product of the individual
  %polynomials on those variables. This function, given data representing a
  %multivariate function, generates a complete multivariate ReSC module written
  %in Verilog, containing the following files:
  % ReSC_[nameSuffix].v - The core stochastic module
  % ReSC_wrapper_[nameSuffix].v - A wrapper for the module that converts inputs
  %                               inputs and outputs between binary and
  %                               stochastic representations.
  % ReSC_test_[nameSuffix].v - A testbench for the system.
  % LFSR_[log(N)]_bit_added_zero_[nameSuffix].v - The RNG for generating
  %                                               stochastic numbers.
  
  %Parameters:
  % data      : a matrix wherein each row contains several inputs and a
  %             corresponding output value of the function being modeled
  % degrees   : the desired degrees of the Bernstein polynomials underlying the
  %             ReSC (one per input, higher means a larger circuit but less
  %             error)
  % N         : the length of the stochastic bitstreams, must be a power of 2
  % m_input   : the length in bits of the input, at most log2(N)
  % m_coeff   : the length in bits of the coefficients, at most log2(N)
  % nameSuffix: a distinguishing suffix to append to the name of each Verilog
  %             module
  
  %Optional Parameters:
  % ConstantRNG: Choose the method for generating the random numbers used in
  %              stochastic generation of the constants. Options:
  %                'SharedLFSR' (default) - Use one LFSR for all weights
  %                'LFSR' - Use a unique LFSR for each weight
  %                'Counter' - Count from 0 to 2^m in order
  %                'ReverseCounter' - Count from 0 to 2^m, but reverse the
  %                                    order of the bits
  % InputRNG: Choose the method for generating the random numbers used in
  %           stochastic generation of the input values. Options:
  %             'LFSR' - Use a unique LFSR for each input
  %             'SingleLFSR' - Use one longer LFSR, giving a unique n-bit
  %                            segment tp each copy of the inputs
  
  addpath(genpath('.'));
  
  min_vals = min(data);
  max_vals = max(data);
  for i=1:size(data, 2)
    data(:,i) = (data(:,i) - min_vals(i)) / (max_vals(i) - min_vals(i));
  end
  
  coeff = MultivariateBernAppr(data, degrees);
  VerilogMultivariateReSCGenerator(coeff, degrees, N, m_input, m_coeff, ...
                                   nameSuffix, ConstantRNG, InputRNG);
end