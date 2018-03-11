% Connect to the arduino, change COM-number as neccessary.
% Need to run the program 2 times for it to start, do not clear variable second start.

keepvars = {'a', 'K', 'L', 'T', 'u', 'y', 't'};
%clear all
a = arduino_com('COM9');
clearvars('-except', keepvars{:});

% Constant parameter values
N = 60*4;  % total samples
dT = 2;     % sampling time
bv1 = 60;   % desired level, in procent (0-100), for tank 1
bv2 = 30;   % desired level, in procent (0-100), for tank 2
OFF = 0;
ON = 1;
p1 = 'a0'; % tank 1
p2 = 'a1'; % tank 2
m = 100; % control output power of pumpmotor (0% - 100%)


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
tank1 = OFF;
tank2 = ON;
KLTMethod = ON;
tumRegelMetoder = ON;

if(KLTMethod == ON)
    disp('KLTMethod == ON ---> tank1 = OFF & tank2 = OFF & tumRegelMetoder = OFF')
    tank1 = OFF;
    tank2 = OFF;
    tumRegelMetoder = OFF;
end


regulatorType = regulator(4).Type;
saveFileVariables = '.\data\zieger-nichols\P.3.1.1.c_zieger-nichols_K0.8_pid_nedre_vattentank.mat';
saveFileFigure = '.\bilder\zieger-nichols\P.3.1.1.c_zieger-nichols_K0.8_pid_nedre_vattentank.jpg';

loadFileVariables = '.\data\P.1.1.1_filtreread_stegsvar_ovre_vattentank.mat';

loop = 1;
% start regulating the tanks...
while(loop)
    
    if(tank1 == ON)
        disp('Regulating tank 1...')
        [y,u,t] = function_regulator(a, N, dT, bv1, p1, m, regulatorType, saveFileFigure);
        save(saveFileVariables,'y','u','t');
    end
    
    if(tank2 == ON)
        disp('Regulating tank 2...')
        if(tumRegelMetoder == ON) %
            [y,u,t,K] = P311_ziegler_nichols(a,N,dT,p2,bv2,10*0.8,10^40,0,saveFileFigure);
            save(saveFileVariables,'y','u','t','K');
        else
            [y,u,t] = function_regulator(a, N, dT, bv2, p2, m, regulatorType, saveFileFigure);
            save(saveFileVariables,'y','u','t');
        end
        
        
    end
    
    if(KLTMethod == ON)
        load(loadFileVariables) %loads filtered default stepanswer for the tanks
        disp('File loaded......')
        disp(loadFileVariables)
        [K,L,T] = F131_KLT(1, y, u, t);
        amigo
        keepvars = {'a', 'K', 'L', 'T', 'u', 'y', 't'};
        clearvars('-except', keepvars{:});
        lambda
    end
    
    analogWrite(a,0,'DAC0')
    loop = loop - 1;
end