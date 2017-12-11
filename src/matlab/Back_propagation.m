function [w2,w3,b2,b3] = Back_propagation(X,w2,w3,b2,b3,t,eta)

% 学習回数 Iteration 
for j = 1:10000
    C=0;
    dCdw2=0;
    dCdw3=0;
    dCdb2=0;
    dCdb3=0;

    for i=1:size(X,2)                     % 学習サンプルだけ繰り返す 	loop for sample data=4
        % 入力→中間層パラメータ	input -> hidden parameter
        k = X(:,i);                       % 一列ごと入力            insert input column by column
        z2 = w2 * k + b2;			            % 中間層の重み付き入力     input weight for hidden layer
        a2= 1./(1+exp(-z2));		          % 中間層の出力           output for hidden layer
        dadz2 = (1-a2).*a2;			          % a2の微分系(da(z2)/dz) differentiation of a2 (differentiation of sigmoid, da(z2)/dz)
    
        % 中間→出力層パラメータ	hidden -> output parameter
        z3 = w3 * a2 + b3;			          % 出力層の重み付き入力		 input weight for output layer
        a3= 1./(1+exp(-z3));		          % 出力層の出力			     output for output layer
        dadz3 = (1-a3).*a3;			          % a3の微分系(da(z3)/dz) differentiation of a3 (differentiation of sigmoid, (da(z3)/dz))
    
        % 誤差逆伝搬法による学習過程		learning process of backpropagation
        % 誤差決定				Error determination
        tx=t(:,i);
    
        Q=sum((tx-a3).^2)/2;
        C = C + Q;                        % 二乗誤差			square error
    
        delta3 = (a3-tx) .* dadz3;		    % 出力層の誤差関数		error funtion for output layer
        delta2 = (w3.' * delta3).*dadz2;  % 中間層の誤差関数		error funtion for hidden layer
    
        % コスト関数の導出			Derivation of Cost funtion 
        o = (a2 * (delta3).').';
        dCdw3 = dCdw3 + o;			          % Partial derivative of C in w3 (dC/dw3 = sum(a2*delta3))
        o = (k * (delta2).').';
        dCdw2 = dCdw2 +o ;			          % Partial derivative of C in w2 (dC/dw2 = sum(k*delta2))
        dCdb3 = dCdb3 + delta3;           % Partial derivative of C in b3 (dC/db3 = sum(delta3))
        dCdb2 = dCdb2 + delta2;           % Partial derivative of C in b2 (dC/db2 = sum(delta2))
    end
    % fprintf('%dth learning C = %g\n',j,C);
    w2 = w2 - eta * dCdw2;
    w3 = w3 - eta * dCdw3;
    b2 = b2 - eta * dCdb2;
    b3 = b3 - eta * dCdb3;
end


% 結果の表示				Result's display
for i=1:size(X,2)				
    % 入力→中間層パラメータ
    k = X(:,i);				
    z2 = w2 * k + b2;			
    a2= 1./(1+exp(-z2));		
    
    % 中間→出力層パラメータ
    z3 = w3 * a2 + b3;			
    a3= 1./(1+exp(-z3))	 
end