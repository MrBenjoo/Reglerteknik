% ------ load a .mat file to filter  ------
load ('.\data\P.1.2.1_stegsvar_undre_vattentank_m25_dt_05.mat')

% ------ save the filtering with the given name and path ------
saveNameMat = '.\data\P.1.2.1_filtered_stegsvar_undre_vattentank_m25_dt_05.mat';
saveNameJPG = '.\Bilder\P.1.2.1_filtered_stegsvar_undre_vattentank_m25_dt_05.jpg';

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
title('Tank 2, filtrerat stegsvar') ;
legend('y');
hold('off');
% -------------------

saveas(figure(3), saveNameJPG);
save(saveNameMat, 'y', 'u', 't');
