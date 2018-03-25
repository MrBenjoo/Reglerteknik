% Connect to the arduino, change COM-number as neccessary.
% Need to run the program 2 times for it to start, do not clear variable second start.

a = arduino_com('COM9');

% values stored in the struct regulator:
%   - 1   = OFF
%   - 2-5 = R1, R2, R3, R4
%   - 6-9 = R1_aw, R2_aw, R3_aw, R4_aw
%   - 10-11 = R1_PID_40percent_zn, R2_PID_40percent_lambdaT
%   - 12-13 = R3_PID_40percent_lambda2T, R4_PID_40percent_amigo
%   - 14-15 = R1_PID_aw_40percent_zn, R2_PID_aw_40percent_lambdaT
%   - 16-17 = R3_PID_aw_40percent_lambda2T, R4_PID_aw_40percent_amigo
toggler = struct('Toggler', {'OFF', 'R1', 'R2','R3','R4','R1_aw','R2_aw','R3_aw','R4_aw',...
    'R1_PID_40percent_zn', 'R2_PID_40percent_lambdaT','R3_PID_40percent_lambda2T','R4_PID_40percent_amigo',...
    'R1_PID_aw_40percent_zn','R2_PID_aw_40percent_lambdaT','R3_PID_aw_40percent_lambda2T','R4_PID_aw_40percent_amigo'});
togglerP421 = toggler(17).Toggler;

saveFileVariables = '.\data\Komplettering_P4.2.x\R4_PID_amigo_40percent.mat';
saveFileFigure = '.\Bilder\Komplettering_P4.2.x\R4_PID_amigo_40percent.jpg';
%Used only if timeCalculations = ON or KLTMethod = ON
loadFileVariables = '.\data\komplettering_stegsvar\P.1.2.1_filtreread_stegsvar_undre_vattentank.mat';

% Constant parameter values
N = 60*10;  % total samples
dT = 2;     % sampling time
bv1 = 40;   % desired level, in procent (0-100), for tank 1
bv2 = 40;   % desired level, in procent (0-100), for tank 2
bv = bv2;
OFF = 0;
ON = 1;
p1 = 'a0'; % tank 1
p2 = 'a1'; % tank 2
m = 30; % control output power of pumpmotor (0% - 100%)
K = 0.86;
TI = 49.8;
TD = 4.9;%1.97;

% Configuration
tank1 = OFF;
tank2 = ON;
KLTMethod = OFF;
tumRegelMetoder = OFF; %ON for zigler-nichols
timeCalculations = OFF;


if(KLTMethod == ON || timeCalculations == ON)
    disp('KLTMethod == ON ---> tank1 = OFF & tank2 = OFF & tumRegelMetoder = OFF')
    tank1 = OFF;
    tank2 = OFF;
    tumRegelMetoder = OFF;
end


% values stored in the struct regulator:
%   - 1 = 'twoStateRegulator',
%   - 2 = 'p_regulator'
%   - 3 = 'pi_regulator',
%   - 4 = 'pid_regulator'
%   - 5 = 'defaultStepAnswer'
%   - 6 = 'pid_aw_regulator'
regulator = struct('Type', {'twoStateRegulator',...
    'p_regulator', 'pi_regulator', 'pid_regulator',...
    'defaultStepAnswer', 'pid_aw_regulator'});
regulatorType = regulator(4).Type;

% start regulating the tanks...
if(tank1 == ON)
    disp('Regulating tank 1...')
    [y,u,t] = function_regulator(a, N, dT, bv1, p1, m, K, TI, TD, regulatorType, saveFileFigure);
    save(saveFileVariables,'y','u','t');
end

if(tank2 == ON)
    disp('Regulating tank 2...')
    if(tumRegelMetoder == ON) %
        [y,u,t] = P311_ziegler_nichols(a,N,dT,p2,bv2,K,TI,TD,saveFileFigure);
        %save(saveFileVariables,'y','u','t','K');
    else
        [y,u,t] = function_regulator(a, N, dT, bv2, p2, m, K, TI, TD, regulatorType, saveFileFigure);
        save(saveFileVariables,'y','u','t');
    end
    
    
end

if(KLTMethod == ON)
    load(loadFileVariables) %loads filtered default stepanswer for the tanks
    disp('File loaded............')
    disp(loadFileVariables)
    [K,L,T] = F131_KLT(1, y, u, t);
    amigo
    lambda
end

if(timeCalculations == ON)
    load(loadFileVariables) %loads regulating
    disp('File loaded............')
    disp(loadFileVariables)
    [stigtid] = F511_stigtid(y,N,bv,dT);
    [insvtid] = F512_insvangningstid(y,N,bv,dT);
    [fv] = F513_kvarstaendefel(y,N,bv);
end
if(tank2 == ON && ~strcmp(togglerP421, 'OFF'))
    switch(togglerP421)
        %R1 output
        case 'R1'
            R1_y_zn = y;
            R1_u_zn = u;
            R1_t_zn = t;
            R1_plot = saveFileFigure;
            
        case 'R2'
            %R2 output
            R2_y_lambdaT = y;
            R2_u_lambdaT = u;
            R2_t_lambdaT = t;
            R2_plot = saveFileFigure;
            
        case 'R3'
            %R3 output
            R3_y_lambda2T  = y;
            R3_u_lambda2T  = u;
            R3_t_lambda2T  = t;
            R3_plot = saveFileFigure;
            
        case 'R4'
            %R4 output
            R4_y_amigo = y;
            R4_u_amigo = u;
            R4_t_amigo = t;
            R4_plot = saveFileFigure;
            
        case 'R1_aw'
            %R1 output
            R1_y_aw = y;
            R1_u_aw = u;
            R1_t_aw = t;
            R1_plot = saveFileFigure;
            
        case 'R2_aw'
            %R2 output
            R2_y_aw = y;
            R2_u_aw = u;
            R2_t_aw = t;
            R2_plot = saveFileFigure;
            
        case 'R3_aw'
            %R3 output
            R3_y_aw  = y;
            R3_u_aw  = u;
            R3_t_aw = t;
            R3_plot = saveFileFigure;
            
        case 'R4_aw'
            %R4 output
            R4_y_aw = y;
            R4_u_aw = u;
            R4_t_aw = t;
            R4_plot = saveFileFigure;
            
        case 'R1_PID_40percent_zn'
            %R1 output
            R1_y_40percent = y;
            R1_u_40percent  = u;
            R1_t_40percent  = t;
            R1_plot_40percent  = saveFileFigure;
            
        case 'R2_PID_40percent_lambdaT'
            %R2 output
            R2_y_40percent   = y;
            R2_u_40percent   = u;
            R2_t_40percent   = t;
            R2_plot_40percent  = saveFileFigure;
            
        case 'R3_PID_40percent_lambda2T'
            %R3 output
            R3_y_40percent = y;
            R3_u_40percent = u;
            R3_t_40percent = t;
            R3_plot_40percent    = saveFileFigure;
            
        case 'R4_PID_40percent_amigo'
            %R4 output
            R4_y_40percent = y;
            R4_u_40percent = u;
            R4_t_40percent = t;
            R4_plot_40percent = saveFileFigure;
            
            
        case 'R1_PID_aw_40percent_zn'
            %R1 output
            R1_y_aw_40percent = y;
            R1_u_aw_40percent  = u;
            R1_t_aw_40percent  = t;
            R1_plot_aw_40percent  = saveFileFigure;
            
        case 'R2_PID_aw_40percent_lambdaT'
            %R2 output
            R2_y_aw_40percent   = y;
            R2_u_aw_40percent   = u;
            R2_t_aw_40percent   = t;
            R2_plot_aw_40percent  = saveFileFigure;
            
        case 'R3_PID_aw_40percent_lambda2T'
            %R3 output
            R3_y_aw_40percent = y;
            R3_u_aw_40percent = u;
            R3_t_aw_40percent = t;
            R3_plot_aw_40percent    = saveFileFigure;
            
        case 'R4_PID_aw_40percent_amigo'
            %R4 output
            R4_y_aw_40percent = y;
            R4_u_aw_40percent = u;
            R4_t_aw_40percent = t;
            R4_plot_aw_40percent = saveFileFigure;
    end
    [stigtid] = F511_stigtid(y,N,bv,dT)
    [insvtid] = F512_insvangningstid(y,N,bv,dT)
    [fv] = F513_kvarstaendefel(y,N,bv)
    clear toggler togglerP421 togglerType Ka Ks L T Td Ti LAMBDA TD saveFileFigure loadFileVariables y u t m ON OFF p1 p2 regulatorType K T0D TI tank1 tank2 timeCalculations tumRegelMetoder saveFileVariables dT bv bv1 bv2 KLTMethod N P421_toggler regulator
    load komplettering_labb1504e
    save komplettering_labb1504e
end
analogWrite(a,0,'DAC1')