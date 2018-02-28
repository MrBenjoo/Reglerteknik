% Connect to the arduino, change COM-number as neccessary.
% Need to run the program 2 times for it to start, do not clear variable second start.
clear all
a = arduino_com('COM3');


h1 = 'a0'; % Beh?llare 1 
h2 = 'a1'; % Beh?llare 2 


% Konstanta parameter-v?rden
N = 60*5; 
dT = 1;
v1 = 516; 
v2 = 128;
% Antar att KTdTi inte beh?vs f?r de f?rsta uppgifterna
%KTdTi = [0.2028, 12.7632, 38.5261]; 
OFF = 0;
ON = 1;


% values stored in the struct regulator:
% 1 = 'twoStateRegulator', 
% 2 = 'multipleStateRegulator'
% 3 = 'p_regulator', 
% 4 = 'pid_regulator' 
% 5 = 'pd_regulator' 
% 6 = 'defaultStepAnswer
regulator = struct('Type', {'twoStateRegulator', 'multipleStateRegulator',...
                    'p_regulator', 'pid_regulator', 'pd_regulator',... 
                    'defaultStepAnswer'});

                
% Konfiguration av programmet
tank1 = OFF;
tank2 = ON;
saveFileVariables = 'P.1.2_stegsvar_undre_vattentank.mat';
saveFileFigure = 'P.1.2_stegsvar_undre_vattentank.jpg';
regulatorType = regulator(6).Type;
loop = 1;
TumregelMetoder = OFF;


% B?rja regleringen av beh?llarna...
while(loop)
   
    if(tank1 == ON)
        disp('Regulating tank 1...')
        % utg?ngsvariabler: 
        %   N samples av stegsvarsignalen
        %   t = tidsvektoren (N tidspunkter i sekunder)
        % ing?ngsvariabler: 
        %   pos[4] --> p = val av inpudTignal
        %   pos[5] --> m = styrning av pumpmotorn mellan 0% - 100%
        disp(regulatorType)
        [N,t] = function_regulator(a, N, dT, v1, h1, 50, regulatorType, saveFileFigure);
        save(saveFileVariables, 'h1', 't'); 
    end
    
    if(tank2 == ON)
        disp('Regulating tank 2...')
        % utg?ngsvariabler: 
        %   N samples av stegsvarsignalen
        %   t = tidsvektoren (N tidspunkter i sekunder)
        % ing?ngsvariabler: 
        %   pos[4] --> p = val av inpudTignal
        %   pos[5] --> m = styrning av pumpmotorn mellan 0% - 100%
        [N,t] = function_regulator(a, N, dT, v1, h2, 50, regulatorType, saveFileFigure);
        %save(saveFileVariables, 'h1', 't');
    end
    
    analogWrite(a,0,'DAC0')
    loop = loop - 1;
end