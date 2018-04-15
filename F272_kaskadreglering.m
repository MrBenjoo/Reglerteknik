function [y,u,t] = F272_kaskadreglering(a,N,dT,bv,K1,TI1,TD1,K2,TI2,TD2,R,saveFile)

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
w1 = zeros(1, N);
w2 = zeros(1, N);
u2 = zeros(1, N);  % vector to be filled with calculations of the signal u
t = (1:N)*dT;      % vector currently as a numbering of times from 1 to N times sampling time
ok=0;              % used to detect too short sampling time
% *************************************************************************************
signalYttreSystem = 0;


% if you want to get rid of strange values in the beginning
% make a "read analog" before the loop of analog inputs:
a.analogRead('a1');



% ******* PART D: start regulating *******
for k=1:N % the loop will run N times, each time takes exactly dT seconds
    
    start = cputime; % start timer to measure exececution of one loop
    if (ok < 0)      % check if sampling time too short
        disp('samplingtime too short! Increase the value for dT');
        return
    end
    
    t(k)=k*dT; % update timevector
    
    % --------------- update control signal and write to DAC1 ---------------
    if(mod(k-1, R) == 0)
        % in till R2 yttre kretsen, undre vattentanken (bäst-rankade
        % inställningar)
        y2(k) = a.analogRead('a1'); % reads value in tank 2
        y1(k) = a.analogRead('a0'); % also reads value in tank1. If we dont read, we will get y2(k) = 0.
       
        if(k>1)
            e2(k) = r(k)-y2(k);
            w2(k) = w2(k-1) + e2(k);
            u2(k) = K2*(e2(k) + dT/TI2*w2(k) + TD2*(e2(k)-e2(k-1))/dT);
        end
        u2(k) = min(max(0, round(u2(k))), 255); % limit the signal between 0-255
        u1(k) = u2(k);
        disp("signal " + u2(k))
        analogWrite(a,u2(k),'DAC1');
        signalYttreSystem = u2(k);
    else
        % in till R2 inre kretsen, övre vattentanken
        y1(k) = a.analogRead('a0'); % reads value in tank 1
        if(k>1)
             disp('signalYttreSystem')
                signalYttreSystem
            e1(k) = signalYttreSystem - y1(k); 
            w1(k) = w1(k-1) + e1(k);
            u1(k) = K1*(e1(k) + dT/TI1*w1(k) + TD1*(e1(k)-e1(k-1))/dT);
            disp('e1')
            e1(k)
            disp('w1')
            w1(k)
            disp('u1')
            u1(k)
        end
        u1(k) = min(max(0, round(u1(k))), 255); % limit the signal between 0-255
        disp("signal " + u1(k))
        analogWrite(a,u1(k),'DAC1');
    end
    % -----------------------------------------------------------------------
    
    
    % ------- online-plot START -------
    figure(1)
    plot(t,y1,'k-',t,u1,'m:',t,r,'g:');
    xlabel('samplingar (k)');
    title('tank 2, level (y), signal (u), desired level(r)');
    disp(y1(k));
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
plot(t,y1,'k-',t,u1,'m:',t,r,'b');
xlabel('samples (k)')
ylabel('level (y), signal (u), desired level (r)')
title('Tank 1, PID regulation');
legend('y ', 'u ', 'r ')

saveas(figure(2), saveFile);
y = y1;
u = u1;

end