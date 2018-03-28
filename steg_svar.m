% Connect to the arduino, change COM-number as neccessary.
if(~exist('a','var'))
    a = arduino_com('COM7');
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
regulatorType = regulator(7).Type;
%************************
% 2. TOGGLER TYPE
%************************
togglerP421 = toggler(18).Toggler;
%************************
% 3. SET CONFIGURATION
%************************
saveFileVariables = '.\data\P.2.1.2_twoState_60m.mat';
savePath = '.\Bilder\Komplettering_P4.2.x\';
savePath = strcat(savePath, togglerP421);
savePath = strcat(savePath, '.jpg');
saveFileFigure = savePath

savePath = '.\data\';
savePath = strcat(savePath, togglerP421);
savePath = strcat(savePath, '.mat');
saveFile  = savePath
tank1 = OFF;
tank2 = ON;
tumRegelMetoder = OFF; % ON for zigler-nichols
KLTMethod = OFF;
% Constant parameter values
N = 60*6;   % total samples
bv1 = 60;   % desired level, in procent (0-100), for tank 1
bv2 = 40;   % desired level, in procent (0-100), for tank 2
bv = bv2;
m = 40;     % control output power of pumpmotor (0% - 100%)

% Ziegler-Nichols
K = 3.0;
TI = 90;
TD = 22.5;

% Amigo
%{
K = 1.09;
TI = 43.03;
TD = 3.94;
%}

% LambdaT
%{
K = 0.125;
TI = 156;
TD = 3.90;
%}


% Used only if timeCalculations = ON or KLTMethod = ON
loadFileVariables = '.\data\komplettering_stegsvar\P.1.2.1_filtreread_stegsvar_undre_vattentank.mat';
if(KLTMethod == ON)
    disp('KLTMethod == ON ---> tank1 = OFF & tank2 = OFF & tumRegelMetoder = OFF')
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
        [y,u,t] = P311_ziegler_nichols(a,N,dT,p2,bv2,K,TI,TD,saveFileFigure);
        save(saveFileVariables,'y','u','t','K');
    else
        [y,u,t] = function_regulator(a, N, dT, bv, p, m, K, TI, TD, regulatorType, saveFile);
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