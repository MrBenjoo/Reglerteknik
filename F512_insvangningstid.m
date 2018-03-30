function [insvtid] = F512_insvangningstid(y,tv,bv,dT)
disp('**************************************')
disp('*** Function: F512_insvangningstid ***')
disp('**************************************')
insvtid =  -1;
% ***************************************************************
%   output values:
%       - insvtid: the time it takes from the beginning until all signal values ??are within the +/- 5% band of the stationary value.
%   argument values:
%       - y:    vector with with measurements of the level in the tank
%       - tv:   vector containing 't' samples (timepoints)
%       - bv:   desired level
%       - dT:   samplingtime in seconds
% ***************************************************************
%insvtid = -1;
H1Max=740; % Max level-value for tank 1
H2Max=745; % Max level-value for tank 2

threshold_0_95 = (bv * H2Max * 0.95)/100;
threshold_1_05 = (bv * H2Max * 1.05)/100;

% temporary vector used for the calculations.
% If we didnt use this vector it would produce wrong settling time
tempV = y;

for k=1:tv
    within_treshold = ( max(tempV) <= threshold_1_05 ) && (min(tempV) >= threshold_0_95);
    if( within_treshold )
        insvtid = ( length(y)-length(tempV) ) * dT;
        disp("Insvängningstiden är: " + insvtid)
        break;
    else
        tempV = y(k:length(y));
    end
end

end



