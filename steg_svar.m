% Connect to the arduino, change COM-number as neccessary.
% Need to run the program 2 times for it to start, do not clear variable second start.

%keepvars = {'a'};
clear all
a = arduino_com('COM7');
%clearvars('-except', keepvars{:});


% Constant parameter values
N = 60*7;  % total samples
dT = 1;    % sampling time
bv1 = 30;  % desired level, in procent (0-100), for tank 1
bv2 = 60;  % desired level, in procent (0-100), for tank 2
OFF = 0;
ON = 1;
p1 = 'a0'; % tank 1
p2 = 'a1'; % tank 2


% values stored in the struct regulator:
%   - 1 = 'twoStateRegulator',
%   - 2 = 'p_regulator'
%   - 3 = 'pi_regulator',
%   - 4 = 'pid_regulator'
%   - 5 = 'defaultStepAnswer'
regulator = struct('Type', {'twoStateRegulator',...
    'p_regulator', 'pi_regulator', 'pid_regulator',...
    'defaultStepAnswer'});


% Configuration
tank1 = ON;
tank2 = OFF;
KLTMethod = ON;

if(KLTMethod == ON)
    disp('KLTMethod == ON ---> tank1 = OFF & tank2 = OFF')
    tank1 = OFF;
    tank2 = OFF;
end

regulatorType = regulator(2).Type;
saveFileVariables = '.\data\P.1.1.1_filtreread_stegsvar_ovre_vattentank.mat';
saveFileFigure = '.\bilder\P.2.2.2_p-reglering_ovre_vattentank.jpg';
loop = 1;
m = 80; % control output power of pumpmotor (0% - 100%)


% start regulating the tanks...
while(loop)
    
    if(tank1 == ON)
        disp('Regulating tank 1...')
        [y,u,t] = function_regulator(a, N, dT, bv1, p1, m, regulatorType, saveFileFigure);
        save(saveFileVariables,'y','u','t');
    end
    
    if(tank2 == ON)
        disp('Regulating tank 2...')
        [y,u,t] = function_regulator(a, N, dT, bv2, p2, m, regulatorType, saveFileFigure);
        save(saveFileVariables,'y','u','t');
    end
    
    if(KLTMethod == ON)
        load(saveFileVariables)
        F131_KLT(a, y, u, t)
    end
    
    analogWrite(a,0,'DAC0')
    loop = loop - 1;
    
end