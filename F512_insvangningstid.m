function [insvtid] = F512_(y,tv)

% hittar f?rsta sample som uppfyller insv?gningsvillkoren, multiplicera samplenummer med samplingstiden 
insvtid = min( find((y>=b*0.95) & (y<=b*1.05) )) * dT

end

