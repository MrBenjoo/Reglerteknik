% Connect to the arduino, change COM-number as neccessary.
% Need to run the program 2 times for it to start, do not clear variable second start.
clear all
a = arduino_com('COM3');


p1 = 'a0'; % Tank 1
p2 = 'a1'; % Tank 2


% Constant parameter values
N = 60*5; % Total samples
dT = 1;   % Sampling time
v1 = 50;  % desired level, in procent (0-100), for tank 1
v2 = 50;  % desired level, in procent (0-100), for tank 2
OFF = 0;
ON = 1;


% values stored in the struct regulator:
% 1 = 'twoStateRegulator',
% 2 = 'multipleStateRegulator'
% 3 = 'p_regulator',
% 4 = 'pi_regulator'
% 5 = 'pid_regulator'
% 6 = 'pd_regulator'
% 7 = 'defaultStepAnswer
regulator = struct('Type', {'twoStateRegulator', 'multipleStateRegulator',...
    'p_regulator', 'pi_regulator', 'pid_regulator', 'pd_regulator',...
    'defaultStepAnswer'});


% Configuration
tank1 = OFF;
tank2 = ON;
saveFileVariables = 'P.1.2.1_stegsvar_undre_vattentank.mat';
saveFileFigure = 'P.1.2.1_stegsvar_undre_vattentank.jpg';
regulatorType = regulator(6).Type;
loop = 1;
TumregelMetoder = OFF;
m = 80; % Control output power of pumpmotor (0% - 100%)


% Start regulating the tanks...
while(loop)
    
    if(tank1 == ON)
        disp('Regulating tank 1...')
        [y,t] = function_regulator(a, N, dT, v2, p1, m, regulatorType, saveFileFigure);
        save(saveFileVariables, 'y', 't');
    end
    
    if(tank2 == ON)
        disp('Regulating tank 2...')
        [y,t] = function_regulator(a, N, dT, v1, p2, m, regulatorType, saveFileFigure);
        save(saveFileVariables, 'y', 't');
    end
    
    analogWrite(a,0,'DAC0')
    loop = loop - 1;
    
end