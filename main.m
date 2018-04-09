% Connect to the arduino, change COM-number as neccessary.
if(~exist('a','var'))
    a = arduino_com('COM3');
end

initiationScript

%First argument: regulator type [int]
%Second argument: toggler type [int]
%Third argument: save path [string]
%Fourth argument: ziegler, lambdaT, lambda2T, amigo [string]
configurationVector = {4, 1, 'P4.2.x\R1', 'ziegler'};
% 1 - Choose regulator type
% 2 - if save figures and variables -> set saveFileVariables and
% saveFileFigure and choose togglerType
% ELSE choose toggler(1).Toggler ('OFF')
% 3. set configurations

%************************
% 1. REGULATOR TYPE
%************************
regulatorType = regulator(cell2mat(configurationVector(1))).Type;
%************************
% 2. TOGGLER TYPE
%************************
togglerP421 = toggler(cell2mat(configurationVector(2))).Toggler;
%************************
% 3. SET CONFIGURATION
%************************

figurePath = strcat('.\Bilder\', cell2mat(configurationVector(3)));
variablePath = strcat('.\data\', cell2mat(configurationVector(3)));

% -------------- SET .JPG PATH --------------
if(strcmp(togglerP421, 'OFF'))
    savePath = '.\Bilder\P.3.1.1_ziegler-nichols_tank2.jpg';
else
    savePath = figurePath;
    savePath = strcat(savePath, togglerP421);
    savePath = strcat(savePath, '.jpg');
end
saveFileFigure = savePath;
% -------------------------------------------

% -------------- SET .MAT PATH --------------
if(strcmp(togglerP421, 'OFF'))
    savePath = '.\data\P.3.1.1_ziegler-nichols_tank2_k4.mat';
else
    savePath = variablePath;
    savePath = strcat(savePath, togglerP421);
    savePath = strcat(savePath, '.mat');
end
saveFile = savePath;
% -------------------------------------------

% Constant parameter values
tank1 = OFF;            % ON to regulate tank1
tank2 = ON;             % ON to regulate tank2
tumRegelMetoder = ON;   % ON for ziegler-nichols
KLTMethod = OFF;        % ON to get KLT parameters
N = 60*12;              % total samples
bv1 = 30;               % desired level, in procent (0-100), for tank 1
bv2 = 30;               % desired level, in procent (0-100), for tank 2
m = 25;                 % control output power of pumpmotor (0% - 100%), used only in F11_defaultStepAnswer


[K,TI,TD] = getParameters(cell2mat(configurationVector(4)));
K 
TI 
TD



% ---------------------------------- KLT ----------------------------------
if(KLTMethod == ON)
    disp('KLTMethod == ON ---> tank1 = OFF & tank2 = OFF & tumRegelMetoder = OFF')
    tank1 = OFF;
    tank2 = OFF;
    tumRegelMetoder = OFF;
    
    loadFileVariables = '.\data\stegsvar\m25\P.1.1.1_filtered_stegsvar_ovre_vattentank_m25_dt_05.mat';
    load(loadFileVariables) % loads filtered default stepanswer for the tanks
    disp('File loaded............')
    disp(loadFileVariables)
    [K,L,T] = F131_KLT(1, y, u, t); % also calculates parameters for amigo and lamda
end
% -------------------------------------------------------------------------




% ---------------------------------- Start regulating the tanks ----------------------------------
if(tank1 == ON)
    disp('Regulating tank 1...')
    [y,u,t] = function_regulator(a, N, dT, bv1, p1, m, K, TI, TD, regulatorType, saveFileFigure);
    save(saveFile,'y','u','t');
end

if(tank2 == ON)
    disp('Regulating tank 2...')
    if(tumRegelMetoder == ON)
        [y,u,t] = P311_ziegler_nichols(a,N,dT,p2,bv2,4,inf,0,saveFileFigure);
        save(saveFile,'y','u','t');
    else
        [y,u,t] = function_regulator(a, N, dT, bv2, p2, m, K, TI, TD, regulatorType, saveFileFigure);
        save(saveFile,'y','u','t');
    end
end
% -----------------------------------------------------------------------------------------------


if(tank2 == ON && ~strcmp(togglerP421, 'OFF'))
    P421(y,u,t,togglerP421, saveFileFigure)
    timeCalculations; % stigtid, insvangningstid, kvarstaendefel
end

analogWrite(a,0,'DAC1')