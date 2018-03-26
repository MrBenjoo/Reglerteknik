% FINAL CONSTANTS
OFF = 0;
ON = 1;
p1 = 'a0'; % tank 1
p2 = 'a1'; % tank 2
dT = 2;     % sampling time

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