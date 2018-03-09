function [insvtid] = F512_insvangningstid(y,tv,bv,dT)

% ***************************************************************
%   output values:
%       - insvtid: the time it takes from the beginning until all signal values ??are within the +/- 5% band of the stationary value.
%   argument values:
%       - y:    vector with with measurements of the level in the tank
%       - tv:   vector containing 't' samples (timepoints)
%       - bv:   desired level
%       - dT:   samplingtime in seconds
% ***************************************************************


% finds the first sample that fullfills "insvängningsvillkoren" and multiplices it with the sampletime
insvtid = min( find( ( y >= bv * 0.95) & ( y <= bv * 1.05 ) ) ) * dT;


disp("Insvängningstiden är: " + insvtid)


end

