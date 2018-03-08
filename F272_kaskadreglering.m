function [y,t] = F261_PID_antiWindup(a,N,dT,bv,K1,TI1,TD1,K2,TI2,TD2,R)

% ******* PART A: Description of the different variables *******
%   output values:
%       - y:    vector containing level values
%       - u:    vector containing signal values
%       - t:    vector containing 't' samples (timepoints)
%   argument values:
%       - a:    arduino-object, accessed with: a = arduino_com('COMxx')
%       - N:    total samples
%       - dT:   samplingtime in seconds
%       - bv:   desired level for the regulation given in procent (0..100%)
%       - K1:    ...
%       - TI1:   ...
%       - TD1:   ...
%       - K2:    ...
%       - TI2:   ...
%       - TD2:   ...
%       - R:     ...
% ***************************************************************


H1Max=740; % Max level-value for tank 1
H2Max=745; % Max level-value for tank 2


% ******* PART B: Initialization of inputs and outputs and internal variables *******
% Calculate desired-level in absolute numbers
r=(bv*H1Max/100)*ones(1,N); % skapar vektor med r i en rad med N element
% *******************************************************************************


% *** PART C: Create and initialize different variables to save measurement results ***
y1 = zeros(1, N);  % vector with N nulls on a (1) row to be filled with measurements of the level in water tank 1 and 2
e1 = zeros(1, N);  % vector with N nulls on a (1) row to be filled with calculations of the error value e
u1 = zeros(1, N);  % vector to be filled with calculations of the signal u
y2 = zeros(1, N);  % vector with N nulls on a (1) row to be filled with measurements of the level in water tank 1 and 2
e2 = zeros(1, N);  % vector with N nulls on a (1) row to be filled with calculations of the error value e
u2 = zeros(1, N);  % vector to be filled with calculations of the signal u
t = (1:N)*dT;      % vector currently as a numbering of times from 1 to N times sampling time
ok=0;              % used to detect too short sampling time
% *************************************************************************************


% ******* PART D: start regulating *******
for k=1:N % the loop will run N times, each time takes exactly dT seconds
    
    start = cputime; % start timer to measure exececution of one loop
    if ok <0 % check if sampling time too short
        k
        disp('samplingtime too short! Increase the value for dT');
        return
    end
    
    
    t(k)=k*dT; % update timevector
    
    
    % --------------- update control signal and write to DAC0 ---------------
    if(mod(k-1, R) == 0)
        analogWrite(a,u1(k),'DAC0');
        % in till R1 yttre kretsen, undre vattentanken
        y1(k) = a.analogRead(1);
        
        e1(k) = r(k)-y1(k);
        u1(k) = K1*(e1(k) + dT/TI1*sum(e)+TD1*(e1(k)-e(k-1))/dT);
    end
    
    % in till R2 inre kretsen, ?vre vattentanken
    y2(k) = a.analogRead(0);
    
    e2(k) = u1(k)-y2(k);
    u2(k) = K2*(e2(k) + dT/TI2*sum(e)+TD2*(e2(k)-e2(k-1))/dT);
    
    u2(k) = min(max(0, round(u2(k))), 255)*(m/100); % limit the signal between 0-255
    disp("signal " + u(k))
    analogWrite(a,u2(k),'DAC0');
    
    u1(k) = min(max(0, round(u1(k))), 255)*(m/100); % limit the signal between 0-255
    disp("signal " + u(k))
    analogWrite(a,u(k),'DAC0');
    % -----------------------------------------------------------------------
    
    
    % ------- online-plot START -------
    figure(1)
    plot(t,y,'k-',t,u,'m:',t,r,'g:');
    xlabel('samplingar (k)');
    if(p == 'a0')
        title('tank 1, level (y), signal (u), desired level(r)');
    else
        title('tank 2, level (y), signal (u), desired level(r)');
    end
    disp(y(k));
    legend('y ', 'u ', 'r ');
    % ---------------------------------
    
    
    elapsed=cputime-start; % counts the amount of time in seconds
    ok=(dT-elapsed);       % saves the time margin in ok
    pause(ok);             % pauses remaining sampling time
    
end % -for (end of the samples)


% PART E: end experiment
analogWrite(a,0,'DAC0'); % turn pump off

end