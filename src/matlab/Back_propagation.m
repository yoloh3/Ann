function [w2,w3,b2,b3] = Back_propagation(X,w2,w3,b2,b3,t,eta)

% �w�K�� Iteration 
for j = 1:10000
    C=0;
    dCdw2=0;
    dCdw3=0;
    dCdb2=0;
    dCdb3=0;

    for i=1:size(X,2)                     % �w�K�T���v�������J��Ԃ� 	loop for sample data=4
        % ���́����ԑw�p�����[�^	input -> hidden parameter
        k = X(:,i);                       % ��񂲂Ɠ���            insert input column by column
        z2 = w2 * k + b2;			            % ���ԑw�̏d�ݕt������     input weight for hidden layer
        a2= 1./(1+exp(-z2));		          % ���ԑw�̏o��           output for hidden layer
        dadz2 = (1-a2).*a2;			          % a2�̔����n(da(z2)/dz) differentiation of a2 (differentiation of sigmoid, da(z2)/dz)
    
        % ���ԁ��o�͑w�p�����[�^	hidden -> output parameter
        z3 = w3 * a2 + b3;			          % �o�͑w�̏d�ݕt������		 input weight for output layer
        a3= 1./(1+exp(-z3));		          % �o�͑w�̏o��			     output for output layer
        dadz3 = (1-a3).*a3;			          % a3�̔����n(da(z3)/dz) differentiation of a3 (differentiation of sigmoid, (da(z3)/dz))
    
        % �덷�t�`���@�ɂ��w�K�ߒ�		learning process of backpropagation
        % �덷����				Error determination
        tx=t(:,i);
    
        Q=sum((tx-a3).^2)/2;
        C = C + Q;                        % ���덷			square error
    
        delta3 = (a3-tx) .* dadz3;		    % �o�͑w�̌덷�֐�		error funtion for output layer
        delta2 = (w3.' * delta3).*dadz2;  % ���ԑw�̌덷�֐�		error funtion for hidden layer
    
        % �R�X�g�֐��̓��o			Derivation of Cost funtion 
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


% ���ʂ̕\��				Result's display
for i=1:size(X,2)				
    % ���́����ԑw�p�����[�^
    k = X(:,i);				
    z2 = w2 * k + b2;			
    a2= 1./(1+exp(-z2));		
    
    % ���ԁ��o�͑w�p�����[�^
    z3 = w3 * a2 + b3;			
    a3= 1./(1+exp(-z3))	 
end