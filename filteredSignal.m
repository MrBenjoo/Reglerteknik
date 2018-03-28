% ------ load a .mat file to filter  ------
load ('.\data\komplettering_stegsvar\P.1.2.1_stegsvar_m30_undre_komplettering.mat')

% ------ save the filtering with the given name and path ------
saveNameMat = '.\data\komplettering_stegsvar\P.1.2.1_filtreread_m30_undre_komplettering.mat';
saveNameJPG = '.\Bilder\komplettering_stegsvar\P.1.2.1_filtreread_m30_undre_komplettering.jpg';

y(1) = y(2);
windowSize = 5;

b = (1/windowSize)*ones(1, windowSize);
c = 1;
y = filter(b,c,y);

% ------- plot -------
figure(3)
plot(t,y,'k-');
xlabel('samples k') ;
ylabel('y');
title('Tank 1, filtrerat stegsvar') ;
legend('y');
hold('off');
% -------------------

saveas(figure(3), saveNameJPG);
save(saveNameMat, 'y', 'u', 't');
