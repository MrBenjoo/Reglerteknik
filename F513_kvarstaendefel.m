function [fv] = F513_kvarstaendefel(y,tv,bv)

% ***************************************************************
%   output values:
%       - fv: residual error (kvarst�ende fel)
%   argument values:
%       - y:    vector with with measurements of the level in the tank
%       - tv:   vector containing 't' samples (timepoints)
%       - bv:   desired level
% ***************************************************************

fv = mean( y( length(y) - 5:length(y) ) ) - bv; % take mean value of the last 5 samples - the desired level

disp("Kvarst�ende fel �r: " + fv)

end

