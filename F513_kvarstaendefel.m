function [fv] = F513_kvarstaendefel(y,tv,bv)
disp('*************************************')
disp('*** Function: F513_kvarstaendefel ***')
disp('*************************************')
% ***************************************************************
%   output values:
%       - fv: residual error (kvarst�ende fel)
%   argument values:
%       - y:    vector with with measurements of the level in the tank
%       - tv:   vector containing 't' samples (timepoints)
%       - bv:   desired level
% ***************************************************************

H1Max=740; % Max level-value for tank 1
H2Max=745; % Max level-value for tank 2

fv = (mean( y( (length(y) - 5):length(y) ) ))- H2Max*bv/100; % take mean value of the last 5 samples - the desired level

disp("Kvarst�ende fel �r: " + fv)

end