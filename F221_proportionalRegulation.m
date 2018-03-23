function [y,u,t] = F221_proportionalRegulation(a,N,dT,p,bv,KP,saveFile)

% ******* PART A: Description of the different variables *******
%   output values:
%       - y:    vector containing level values
%       - u:    vector containing signal values
%       - t:    vector containing 't' samples (timepoints)
%   argument values:
%       - a:    arduino-object, accessed with: a = arduino_com('COMxx')
%       - N:    total samples
%       - dT:   samplingtime in seconds
%       - p:    inputsignal (tank1 or tank2)
%       - bv:   desired level for the regulation given in procent (0..100%)
%       - KP:   how fast to change the control signal
% ***************************************************************

H1Max=740; % Max level-value for tank 1
H2Max=745; % Max level-value for tank 2

% ******* PART B: Initialization of inputs and outputs and internal variables *******
% Calculate desired-level in absolute numbers
r=(bv*H1Max/100)*ones(1,N); % skapar vektor med r i en rad med N element
% *******************************************************************************


% *** PART C: Create and initialize different variables to save measurement results ***
y = zeros(1, N);  % vector with N nulls on a (1) row to be filled with measurements of the level in water tank 1 and 2
e = zeros(1, N);  % vector with N nulls on a (1) row to be filled with calculations of the error value e
u = zeros(1, N);  % vector to be filled with calculations of the signal u
t = (1:N)*dT;     % vector currently as a numbering of times from 1 to N times sampling time
ok=0;             % used to detect too short sampling time
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
    
    
    % ------------ Read sensor values  ------------
    y(k)= a.analogRead(p); % measure water level in tank 1 or 2 depending on variable p
    e(k)= r(k)-y(k); % calculate the error (desired level - actual level)
    disp("r(k) = " + r(k) + " y(k) =" + y(k))
    % ---------------------------------------------
    
    
    % --------------- update control signal and write to DAC1 ---------------
    u(k) = KP * e(k); % p-regulator, default value KP=1
    u(k) = min(max(0, round(u(k))), 255); % limit the signal between 0-255
    disp("signal u(k) = " + u(k))
    analogWrite(a,u(k),'DAC1');
    % -----------------------------------------------------------------------
    
    
    % ------- online-plot START -------
    figure(1)
    plot(t,y,'k-',t,u,'m:',t,r,'g:');
    xlabel('samplingar (k)');
    if(p == 'a0')
        title('tank 1 P-regulation, level (y), signal (u), desired level(r)');
    else
        title('tank 2 P-regulation, level (y), signal (u), desired level(r)');
    end
    disp(y(k));
    legend('y ', 'u ', 'r ');
    % ---------------------------------
    
    
    elapsed=cputime-start; % counts the amount of time in seconds
    ok=(dT-elapsed);       % saves the time margin in ok
    pause(ok);             % pauses remaining sampling time
    
end % -for (end of the samples)


% PART E: end experiment
analogWrite(a,0,'DAC1'); % turn pump off


% plot a final picture
figure(2)
if(p == 'a0')
    plot(t,y,'k-',t,u,'m:',t,r,'g:');
    xlabel('samplingar (k)')
    ylabel('level (y), signal (u), desired level (r)')
    title('Tank 1, P-regulation');
    legend('y ', 'u ', 'r ')
else
    plot(t,y,'k-',t,u,'m:',t,r,'g:');
    xlabel('samplingar (k)')
    ylabel('level (y), signal (u), desired level (r)')
    title('Tank 2, P-regulation');
    legend('y ', 'u ', 'r ')
end

saveas(figure(2), saveFile);

end