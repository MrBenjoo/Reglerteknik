function [stigtid] = F511_stigtid(y,tv,bv,dT)
disp('******************************')
disp('*** Function: F511_stigtid ***')
disp('******************************')
% ***************************************************************
%   output values:
%       - stigtid: the time it takes for the level to go from 10% to 90%
%   argument values:
%       - y:    vector with with measurements of the level in the tank
%       - tv:   vector containing 't' samples (timepoints)
%       - bv:   desired level
%       - dT:   samplingtime in seconds
% ***************************************************************

H1Max=740; % Max level-value for tank 1
H2Max=745; % Max level-value for tank 2

y(1) = y(2);
% finds all samples (indices) between 10% and 90% of the desired level for the given tank
y10 = (bv * H2Max * 0.1)/100;
y90 = (bv * H2Max * 0.9 )/100;

index10 = find( ( y>= y10 ) , 1 );
index90 = find( ( y>= y90 ) , 1 );

% get the indicies in the format of 1,2,3,4,5.... and then multiple with dT to get time it takes to go from 10% to 90%
stigtid = ( index90 - index10 ) * dT;

disp("Stigtiden är: " + stigtid)


end

