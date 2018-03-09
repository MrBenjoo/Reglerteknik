function [stigtid] = F511_stigtid(y,tv,bv,dT)

s = find( (y>=bv*0.1) & (y<=bv*0.9) ); % all samples between between 10% and 90 % of the desired level for given tank
stigtid = ( max(s)-min(s) ) * dT; % the time it takes to go from 10% to 90%

end

