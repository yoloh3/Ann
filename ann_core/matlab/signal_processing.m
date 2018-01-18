clear all;
close all;

%  k=[8 8 5 5 6 1;
%     8 5 8 5 6 1];
%  t=[1 0 0 0 1 1;
%     0 1 1 1 0 0];
%
% k=[8 8 5 5 2 9 6 4;
%    8 5 8 5 2 9 3 6];
% t=[1 0 0 0 1 1 1 0;
%    0 1 1 1 0 0 0 1];

%  k=[8 8 5 5 2;
%     8 5 8 5 2];
%  t=[1 0 0 0 1;
%     0 1 1 1 0];

 k=[8 8 5 5 3;
    8 5 8 5 3];		%input matrix for supervisor data
% Labeled output
 t=[1 0 0 0 1;
    0 1 1 1 0];

% Initialization values of weights (Hidden layer and Output layer)
w2=[0.1 0.4;
    0.3 0.5;
    0.6 0.1];	%	hidden layer's weight matrix for supervisor data

w3=[0.7 0.2 1.3;
    0.2 0.5 1.1];	% output layer's weight matrix for supervisor data

% Initialization values of bias (Hidden layer and Output layer) 
b2=[-1;
    -1;
    -1];

%b_2=randn(32,1);
b3=[-1;
    -1];

%b_3=randn(3,1);

% Step size
eta = 0.2
%Learning rate. If the learning rate is too high, the updated coefficient becomes too large and the cost may not decrease

%%
% Forward Process (Initial weight)
[sweet,sour]=meshgrid(0:0.1:9.9, 0:0.1:9.9);
X = [reshape(sweet,1,100*100); reshape(sour,1,100*100)];
z2 = w2 * X + b2*ones(1,size(X,2));			    % input weight for hidden layer
a2= 1./(1+exp(-z2));                            % output for hidden layer
z3 = w3 * a2 + b3*ones(1,size(X,2));		    % input weight for output layer
a3= 1./(1+exp(-z3));                            % output for output layer

% Plot figure
figure(1); 
mesh([0:0.1:9.9],[0:0.1:9.9],reshape(a3(1,:),100,100));
zlim([0 1]); view([0 90]);
grid('on'); hold('all');
title('a^3_1 (Initial weight)');
xlabel('Sweetness'); ylabel('Sourness');
colorbar(); caxis([0 1]);

% Plot figure
figure(2); 
mesh([0:0.1:9.9],[0:0.1:9.9],reshape(a3(2,:),100,100));
zlim([0 1]); view([0 90]);
grid('on'); hold('all');
title('a^3_2 (Initial weight)');
xlabel('Sweetness'); ylabel('Sourness');
colorbar(); caxis([0 1]);
%%

[w2,w3,b2,b3] = Back_propagation(k,w2,w3,b2,b3,t,eta);	% Learning

%%
% Forward Process (Final weight)
[sweet,sour]=meshgrid(0:0.1:9.9, 0:0.1:9.9);
X = [reshape(sweet,1,100*100); reshape(sour,1,100*100)];
z2 = w2 * X + b2*ones(1,size(X,2));			        % input weight for hidden layer
a2= 1./(1+exp(-z2));                            	% output for hidden layer
z3 = w3 * a2 + b3*ones(1,size(X,2));			    % input weight for output layer
a3= 1./(1+exp(-z3));                            	% output for output layer

% Plot figure
figure(3); 
mesh([0:0.1:9.9],[0:0.1:9.9],reshape(a3(1,:),100,100));
zlim([0 1]); view([0 90]);
grid('on'); hold('all');
title('a^3_1 (Final weight)');
xlabel('Sweetness'); ylabel('Sourness');
colorbar(); caxis([0 1]);

% Plot figure
figure(4); 
mesh([0:0.1:9.9],[0:0.1:9.9],reshape(a3(2,:),100,100));
zlim([0 1]); view([0 90]);
grid('on'); hold('all');
title('a^3_2 (Final weight)');
xlabel('Sweetness'); ylabel('Sourness');
colorbar(); caxis([0 1]);
