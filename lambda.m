%Run F131_KLT.m first in order for K, L and T
%variables to be available
disp('***************************')
disp('*** Execution: lambda.m ***')
disp('***************************')
Ks = K;

%p = 3
%m = 1
LAMBDA = T

disp('PI-regulator, lmabda = T');
Ka = (1/Ks)*(T/(L-LAMBDA))
Ti = T

disp('PID-regulator, lambda = T');
Ka = (1/Ks)*(L/2+T)/(L/2+LAMBDA)
Ti = T + L/2
Td = T*L / (L + 2*T)

LAMBDA = 2*T

disp('PI-regulator, lmabda = 2T');
Ka = (1/Ks)*(T/(L-LAMBDA))
Ti = T

disp('PID-regulator, lambda = 2T');
Ka = (1/Ks)*(L/2+T)/(L/2+LAMBDA)
Ti = T + L/2
Td = T*L / (L + 2*T)

