load ('.\data\P.1.1.1_stegsvar_ovre_vattentank.mat')

windowSize = 5;

b = (1/windowSize)* ones(1, windowSize);

a = 1;

h1 = filter(b,a,h1);

saveNameMat = 'filtreread_stegsvar_ovre_vattentank.mat';
saveNameJPG = 'filtreread_stegsvar_ovre_vattentank.jpg';

  figure(3)
  plot(t,y,'k-');
  xlabel('samples k') ;
  ylabel('y');
  title('Tank 1, stegsvar') ;
  legend('y');
  hold('off');
  
  saveas(figure(3), saveNameJPG);
  save(saveNameMat, 'y', 't');
  