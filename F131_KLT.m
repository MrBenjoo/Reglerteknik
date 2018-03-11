function [K, L, T] = F131_KLT(a, y, u, tv)

%   output values:
%       - K:  system static gain
%       - L:  dead time
%       - T:  system time constant (the time it takes to reach 63% of the max value)
%   argument values:
%       - a:  arduino-object, accessed with: a = arduino_com('COMxx')
%       - y:  vector containing level values from the step response. According to the lab guidance, the variable 'y' is called 'x' but we call it 'y'
%       - u:  the values ??of the step height used for the step response (= control signal to the motor), set at the first sample (probably between 0 and 255)
%       - tv: time vector with time from the start of the step response experiment in seconds
% *********************************************************************************************************************************************************


indexOfChange = 0;
N = length(tv);


% --------------- FIND 'K' PARAMETER ---------------
% system static gain is the final value of the step response because the stepvalue is constant.
% the last 10 values ??are read and based on these, the average is calculated.
latestValues = y(find(y,10,'last'));
K = mean(latestValues)/u(2)
% ---------------------------------------------



% --------------- FIND 'L' PARAMETER ---------------
% finding the index where the regulation starts showing effect.
% I = position of the highest value M.
[~,I] = max(diff(y));  % get the largest difference between two samples ( y(k) - y(k-1) ) and store it in I.
threshold = y(I)*0.05; % set the threshold to be 5% of the value stored in I.

for k=1:N
    if(y(k) > threshold)
        indexOfChange = k;
        break;
    end
end

L = indexOfChange
% ---------------------------------------------



% --------------- FIND 'T' PARAMETER ---------------
% highest value stored at index M
% I = position of the highest value M.

I = min(find(y > max(y*0.63)));

T = I - L %antal sekunder
% ---------------------------------------------

end