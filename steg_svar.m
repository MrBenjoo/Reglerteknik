% Connect to the arduino, change COM-number as neccessary.
% Need to run the program 2 times for it to start, do not clear variable second start.
% clear all
% a = arduino_com('COM17');


h1 = 'a0'; % Behållare 1 
h2 = 'a1'; % Behållare 2 


% Konstanta parameter-värden
N = 360*3; %3 min * X
Ts = 0.5;
v1 = 516; 
v2 = 128;
% Antar att KTdTi inte behövs för de första uppgifterna
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
tank1 = ON;
tank2 = OFF;
savefileVariables = 'B21_stegsvarmätning_övre_vattentank_ofInterest.mat';
savefileFigure = 'stegsvarmätning_övre_vattentank_ofInterest.jpg';
regulatorType = regulator(6).Type;
loop = 1;
TumregelMetoder = OFF;


% Börja regleringen av behållarna...
while(loop)
   
    if(tank1 == ON)
        disp('Regulating tank 1...')
        
        % y = N samples av stegsvarsignalen
        % t = tidsvektoren (N tidspunkter i sekunder)
        [y,t] = function_regulator(a, N, Ts, v1, h1, regulatorType, savefileFigure);
        save(savefileVariables, 'y', 't');
        
        % nedan är kod från vårterminen 17 
        % [e1, u1, y1, t1, totalTimeElapsed] = function_regulator(a, N, Ts, v1, h1, regulatorType, KTdTi, savefileFigure);
        % [e1, u1, y1, t1, totalTimeElapsed] = function_regulator(a, N, Ts, v1, h1, regulatorType, savefileFigure);
        % disp('Styrvärdet: u1(k)= ' )
        % u1(N) = u1(N)
        % disp('Total time elapsed: ')
        % totalTimeElapsed;
        % save(savefileVariables, 'e1', 'u1', 'y1', 't1', 'totalTimeElapsed', 'Ts', 'KTdTi');
    end
    
    if(tank2 == ON)
        disp('Regulating tank 2...')
        
        % y = N samples av stegsvarsignalen
        % t = tidsvektoren (N tidspunkter i sekunder)
        [y,t] = function_regulator(a, N, Ts, v1, h1, regulatorType, savefileFigure);
        save(savefileVariables, 'y', 't');
        
        % nedan är kod från vårterminen 17 
        %[e2, u2, y2, t2, totalTimeElapsed] = function_regulator(a, N, Ts, v2, h2, regulatorType, KTdTi, savefileFigure);
        %if( TumregelMetoder == ON)
            % Behöver variera K Ti o Td värden för att hitta självsvängning
            % Börjar med att variera bara K för en P-regulator
            % Efteråt Ti för en PI-regulator
            % Slutligen Td för en PID-regulator
            % Alltså en parameter i taget bestäms
            %save(savefileVariables, 'e2', 'u2', 'y2', 't2', 'totalTimeElapsed', 'Ts', 'KTdTi');
        %else
             %save(savefileVariables, 'e2', 'u2', 'y2', 't2', 'totalTimeElapsed', 'Ts', 'KTdTi');
        %end
        
        %disp('Styrvärdet: u2(k)= ' )
        %u2(N) = u2(N)
        %disp('Total time elapsed: ')
        %totalTimeElapsed
    end
    
    analogWrite(a,0,'DAC0')
    loop = loop - 1;
end

