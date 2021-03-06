%Run F131_KLT.m first in order for K, L and T
%variables to be available
disp('***************************')
disp('*** Execution: amigo.m  ***')
disp('***************************')
Ks = K;

disp('PI-regulator');
Ka = (1/Ks)*(0.15+0.35*T/L-T^2/(L+T)^2)
Ti = 0.35 * L +(13 * L*T^2) / ( T^2 + 12*L*T + 7*L^2)

disp('PID-regulator');
Ka = (1/Ks)*(0.2+0.45*T/L)
Ti = ((0.4*L + 0.8*T) / (L + 0.1*T)) * L
Td = ((0.5*L*T) / (0.3*L + T))