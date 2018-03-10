load('LambdaMetodenLTKs.mat')

K = (1/Ks)*(0.2+0.45*T/L);

Ti = ((0.4 * L + 0.8 * T) / ( L + 0.1 * T )) * L;

Td = ( (0.5 * L*T) / (0.3 * L + T));

save('AmigoMetodenKTiTd.mat', 'K', 'Ti', 'Td');

