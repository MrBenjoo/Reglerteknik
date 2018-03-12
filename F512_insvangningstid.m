function [insvtid] = F512_insvangningstid(y,tv,bv,dT)
disp('**************************************')
disp('*** Function: F512_insvangningstid ***')
disp('**************************************')
% ***************************************************************
%   output values:
%       - insvtid: the time it takes from the beginning until all signal values ??are within the +/- 5% band of the stationary value.
%   argument values:
%       - y:    vector with with measurements of the level in the tank
%       - tv:   vector containing 't' samples (timepoints)
%       - bv:   desired level
%       - dT:   samplingtime in seconds
% ***************************************************************

H1Max=740; % Max level-value for tank 1
H2Max=745; % Max level-value for tank 2

threshold_0_95 = (bv * H2Max * 0.95)/100;
threshold_1_05 = (bv * H2Max * 1.05)/100;

% finds the first sample that fullfills "insvängningsvillkoren" and multiplices it with the sampletime
insvtid = min( find( ( y >= threshold_0_95) & ( y <= threshold_1_05 ) ) ) * dT;


disp("Insvängningstiden är: " + insvtid)


end

