function [stigtid] = F511_stigtid(y,tv,bv,dT)

% ***************************************************************
%   output values:
%       - stigtid: the time it takes for the level to go from 10% to 90%
%   argument values:
%       - y:    vector with with measurements of the level in the tank
%       - tv:   vector containing 't' samples (timepoints)
%       - bv:   desired level
%       - dT:   samplingtime in seconds
% ***************************************************************

% finds all samples (indices) between 10% and 90% of the desired level for the given tank
interval = find( ( y >= bv * 0.1 ) & ( y <= bv * 0.9 ) );

% get the indicies in the format of 1,2,3,4,5.... and then multiple with dT to get time it takes to go from 10% to 90%
stigtid = ( max(interval) - min(interval) ) * dT;

disp("Stigtiden är: " + stigtid)

end

