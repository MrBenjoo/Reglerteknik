% Connect to the arduino, change COM-number as neccessary.
% Need to run the program 2 times for it to start, do not clear variable second start.
%keepvars = {'a'};
clear all
a = arduino_com('COM3');
%clearvars('-except', keepvars{:});



p1 = 'a0'; % Tank 1
p2 = 'a1'; % Tank 2


% Constant parameter values
N = 60*7; % Total samples
dT = 1;   % Sampling time
bv1 = 30;  % desired level, in procent (0-100), for tank 1
bv2 = 60;  % desired level, in procent (0-100), for tank 2
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
tank1 = ON;
tank2 = OFF;

KLTMethod = OFF;
if(KLTMethod == ON)
    disp('KLTMethod == ON ---> tank1 = OFF & tank2 = OFF')
    tank1 = OFF;
    tank2 = OFF;
end
%'.\data\P.1.2.1_stegsvar_undre_vattentank.mat'
%'.\data\P.1.1.1_stegsvar_ovre_vattentank.mat'
saveFileVariables = '.\data\P.2.2.2_p-reglering_ovre_vattentank.mat';
saveFileFigure = '.\bilder\P.2.2.2_p-reglering_ovre_vattentank.jpg';
regulatorType = regulator(3).Type;
loop = 1;
% TumregelMetoder = OFF;
m = 80; % Control output power of pumpmotor (0% - 100%)


% Start regulating the tanks...
while(loop)
    
    if(tank1 == ON)
        disp('Regulating tank 1...')
        [y,u,t] = function_regulator(a, N, dT, bv1, p1, m, regulatorType, saveFileFigure);
        save(saveFileVariables, 'y','u', 't');
    end
    
    if(tank2 == ON)
        disp('Regulating tank 2...')
        [y,u,t] = function_regulator(a, N, dT, bv2, p2, m, regulatorType, saveFileFigure);
        save(saveFileVariables, 'y', 'u', 't');
    end
    
    if(KLTMethod == ON)
        load(saveFileVariables)
        F131_KLT(a, y, u, t)
    end
        
        
    
    analogWrite(a,0,'DAC0')
    loop = loop - 1;
    
end