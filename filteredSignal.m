load ('.\data\komplettering_stegsvar\P.1.2.1_stegsvar_komplettering.mat')
y(1) = y(2);
windowSize = 5;

b = (1/windowSize)* ones(1, windowSize);

a = 1;

y = filter(b,a,y);

saveNameMat = '.\data\komplettering_stegsvar\P.1.2.1_filtreread_stegsvar_undre_vattentank.mat';
saveNameJPG = '.\Bilder\komplettering_stegsvar\P.1.2.1_filtreread_stegsvar_undre_vattentank.jpg';

figure(3)
plot(t,y,'k-');
xlabel('samples k') ;
ylabel('y');
title('Tank 1, filtrerat stegsvar') ;
legend('y');
hold('off');

saveas(figure(3), saveNameJPG);
save(saveNameMat, 'y', 'u', 't');
