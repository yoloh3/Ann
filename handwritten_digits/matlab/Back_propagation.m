%clc
%clear
%
%%% Set input neural
%
%k_set     = [8 8 5 5 3;
%             8 5 8 5 3];
%
%t_set     = [1 0 0 0 1;
%         	 0 1 1 1 0];
%
%% Random weight
%
%% w2 = randi([-10 10], 3, 2)
%% w3 = randi([-10 10], 2, 3)
%% b2 = randi([-10 10], 3, 1)
%% b3 = randi([-10 10], 2, 1)
%
%%Fix weight
%
%w2        = [0.1 0.4;
%			 0.3 0.5;
%			 0.6 0.1];
%
%w3        = [0.7 0.2 1.3;
%			 0.2 0.5 1.1];
%
%b2        = [-1;
%			 -1;
%			 -1];
%
%b3        = [-1;
%			 -1];
%
%eta       = 0.05;
%
%%% Calculation
function [w2,w3,b2,b3] = Back_propagation(k_set,w2,w3,b2,b3,t,eta)

a3 = zeros(3, 10000);
mse = [];
for j = 1:10000
    C     = 0;
    dCdw2 = 0;
    dCdw3 = 0;
    dCdb2 = 0;
    dCdb3 = 0;
    
    for i = 1:size(k_set,2)                     % loop for sample data=4
        k        = k_set(:,i);					% insert_set k_set_set column by column
        z2       = w2 * k + b2;                 % k_set_set weight_set for hidden layer
        a2       = 1./(1+exp(-z2));             % output_set for hidden layer
        dadz2    = (1-a2).*a2;                  % differentiation of a2 (differentiation of sigmoid, da(z2)/dz)
    
        % hidden -> output_set parameter
        z3      = w3 * a2 + b3;                 % k_set_set weight_set for output_set layer
        a3(:, j) = 1./ (1 + exp(-z3));          % output_set for output_set layer
        dadz3    = (1 - a3(:, j)).* a3(:, j);	% differentiation of a3 (differentiation of sigmoid, (da(z3)/dz))
    
        % error determination
        tx       = t(:, i);
    
        Q        = sum((tx - a3(:, j)).^ 2) / 2;
        C        = C + Q;						% square error
    
        delta3   = (a3(:, j) - tx).* dadz3;     % error funtion for output_set layer
        delta2   = (w3.' * delta3).* dadz2;     % error funtion for hidden layer
    
        % Derivation of Cost_set funtion 
        o        = (a2 * (delta3).').';
        dCdw3    = dCdw3 + o;					% Partial derivative of C in w3 (dC/dw3 = sum(a2*delta3))
        o        = (k * (delta2).').';
        dCdw2    = dCdw2 +o ;					% Partial derivative of C in w2 (dC/dw2 = sum(k*delta2))
        dCdb3    = dCdb3 + delta3;				% Partial derivative of C in b3 (dC/db3 = sum(delta3))
        dCdb2    = dCdb2 + delta2;				% Partial derivative of C in b2 (dC/db2 = sum(delta2))
    end

    w2 = w2 - eta * dCdw2;
    w3 = w3 - eta * dCdw3;
    b2 = b2 - eta * dCdb2;
    b3 = b3 - eta * dCdb3;

    mse = [mse Q];
end

%Result's display
for i = 1:size(k_set,2)				
	k_  = k_set(:,i);				
	z2_ = w2 * k_ + b2;			
	a2_ = 1./(1+exp(-z2_));		

	z3_ = w3 * a2_ + b3;			
	a3_ = 1./(1+exp(-z3_))
end

save('a3')
plot(mse)
title('Mean square error');
    
