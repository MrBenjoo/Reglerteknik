% Connect to the arduino, change COM-number as neccessary.
if(~exist('a','var'))
    a = arduino_com('COM9');
end

initiationScript

% 1 - Choose regulator type
% 2 - if save figures and variables -> set saveFileVariables and
% saveFileFigure and choose togglerType
% ELSE choose toggler(1).Toggler ('OFF')
% 3. set configurations

%************************
% 1. REGULATOR TYPE
%************************
regulatorType = regulator(4).Type;
%************************
% 2. TOGGLER TYPE
%************************
togglerP421 = toggler(1).Toggler;
%************************
% 3. SET CONFIGURATION
%************************

% -------------- JPG path --------------
if(strcmp(togglerP421, 'OFF'))
    savePath = '.\Bilder\P.3.1.1_ziegler-nichols_tank2_k4.jpg';
else
    savePath = '.\Bilder\P4.2.x\R4\';
    savePath = strcat(savePath, togglerP421);
    savePath = strcat(savePath, '.jpg');
end
saveFileFigure = savePath;
% -------------------------------------

% -------------- DATA path --------------
if(strcmp(togglerP421, 'OFF'))
    savePath = '.\data\P.3.1.1_ziegler-nichols_tank2_k4.mat';
else
    savePath = '.\data\P4.2.x\R4\';
    savePath = strcat(savePath, togglerP421);
    savePath = strcat(savePath, '.mat');
end
saveFile = savePath;
% -------------------------------------

tank1 = OFF;
tank2 = ON;
tumRegelMetoder = ON; % ON for zigler-nichols
KLTMethod = OFF;
% Constant parameter values
N = 60*10;  % total samples
bv1 = 50;   % desired level, in procent (0-100), for tank 1
bv2 = 50;   % desired level, in procent (0-100), for tank 2
bv = bv2;
m = 25;     % control output power of pumpmotor (0% - 100%)

% Ziegler-Nichols
%{
K = 3.0;
TI = 90;
TD = 22.5;
%}

% LambdaT
%{
K = 0.117;
TI = 146;
TD = 1.485;
%}

% Lambda2T
%{
K = 0.059;
TI = 146;
TD = 1.485;
%}

% Amigo
%{
K = 2.56;
TI = 20.08;
TD = 1.49;
%}


% Used only if timeCalculations = ON or KLTMethod = ON
if(KLTMethod == ON)
    disp('KLTMethod == ON ---> tank1 = OFF & tank2 = OFF & tumRegelMetoder = OFF')
    loadFileVariables = '.\data\stegsvar\m25\P.1.1.1_filtered_stegsvar_ovre_vattentank_m25_dt_05.mat';
    tank1 = OFF;
    tank2 = OFF;
    tumRegelMetoder = OFF;
end


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
        [y,u,t] = function_regulator(a, N, dT, bv, p, m, K, TI, TD, regulatorType, saveFileFigure);
        save(saveFile,'y','u','t');
    end
end
% -----------------------------------------------------------------------------------------------


if(KLTMethod == ON)
    load(loadFileVariables) % loads filtered default stepanswer for the tanks
    disp('File loaded............')
    disp(loadFileVariables)
    [K,L,T] = F131_KLT(1, y, u, t); % also calculates parameters for amigo and lamda
end

if(tank2 == ON && ~strcmp(togglerP421, 'OFF'))
    P421(y,u,t,togglerP421, saveFileFigure)
    timeCalculations; % stigtid, insvangningstid, kvarstaendefel
end

analogWrite(a,0,'DAC1')