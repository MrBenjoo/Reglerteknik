% Connect to the arduino, change COM-number as neccessary.
% Need to run the program 2 times for it to start, do not clear variable second start.
% clear all
% a = arduino_com('COM17');


h1 = 'a0'; % Beh�llare 1 
h2 = 'a1'; % Beh�llare 2 


% Konstanta parameter-v�rden
N = 360*3; %3 min * X
Ts = 0.5;
v1 = 516; 
v2 = 128;
% Antar att KTdTi inte beh�vs f�r de f�rsta uppgifterna
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
savefileVariables = 'B21_stegsvarm�tning_�vre_vattentank_ofInterest.mat';
savefileFigure = 'stegsvarm�tning_�vre_vattentank_ofInterest.jpg';
regulatorType = regulator(6).Type;
loop = 1;
TumregelMetoder = OFF;


% B�rja regleringen av beh�llarna...
while(loop)
   
    if(tank1 == ON)
        disp('Regulating tank 1...')
        
        % y = N samples av stegsvarsignalen
        % t = tidsvektoren (N tidspunkter i sekunder)
        [y,t] = function_regulator(a, N, Ts, v1, h1, regulatorType, savefileFigure);
        save(savefileVariables, 'y', 't');
        
        % nedan �r kod fr�n v�rterminen 17 
        % [e1, u1, y1, t1, totalTimeElapsed] = function_regulator(a, N, Ts, v1, h1, regulatorType, KTdTi, savefileFigure);
        % [e1, u1, y1, t1, totalTimeElapsed] = function_regulator(a, N, Ts, v1, h1, regulatorType, savefileFigure);
        % disp('Styrv�rdet: u1(k)= ' )
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
        
        % nedan �r kod fr�n v�rterminen 17 
        %[e2, u2, y2, t2, totalTimeElapsed] = function_regulator(a, N, Ts, v2, h2, regulatorType, KTdTi, savefileFigure);
        %if( TumregelMetoder == ON)
            % Beh�ver variera K Ti o Td v�rden f�r att hitta sj�lvsv�ngning
            % B�rjar med att variera bara K f�r en P-regulator
            % Efter�t Ti f�r en PI-regulator
            % Slutligen Td f�r en PID-regulator
            % Allts� en parameter i taget best�ms
            %save(savefileVariables, 'e2', 'u2', 'y2', 't2', 'totalTimeElapsed', 'Ts', 'KTdTi');
        %else
             %save(savefileVariables, 'e2', 'u2', 'y2', 't2', 'totalTimeElapsed', 'Ts', 'KTdTi');
        %end
        
        %disp('Styrv�rdet: u2(k)= ' )
        %u2(N) = u2(N)
        %disp('Total time elapsed: ')
        %totalTimeElapsed
    end
    
    analogWrite(a,0,'DAC0')
    loop = loop - 1;
end

