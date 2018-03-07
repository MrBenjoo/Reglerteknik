function [y,t] = function_regulator(a, N, dT, bv, p, m, regulatorType, saveFile)

% P?/av-regulering av vattenmodellen (niv? h1 och h2), f?r h1

% ******* DEL A: Beskrivning av de olika variablerna *******

% output values:
%   - N: total samples
%   - t: timevector with N samples in seconds

% argument values:
%   - a: arduino-object, accessed with: a = arduino_com('COMxx')
%   - N: total samples
%   - Ts: samplingtime in seconds
%   - bv: desired level for the regulation (0..100%)
%   - p: inputsignal ('A0' or 'A1')
% ********************************************************

% 100% level-value for tank1 and tank2
H1Max=740; % Max level-value for tank 1
H2Max=745; % Max level-value for tank 2

% ******* DEL B: Initialisering av in- och utg?ngar och interna variabler *******
% analoga ing?ngar f?r m?tning av vattenniv?: 'A0', 'A1'
% analog utg?ng f?r pumpstyrningen, v?lj analog utg?ng 'DAC0'
% R?kna ut b?rv?rdet i absoluta tal

r=(bv*H1Max/100)*ones(1,N); % skapar vektor med r i en rad med N element

% *******************************************************************************



% *** DEL C: Skapa och initialisera olika variabler f?r att kunna spara m?tresultat ***
% skapa vektorer f?r att spara m?tv?rden under experimentet, genom att fylla en vektor med N-nullor
h1 = zeros(1, N); %vektor med N nullor p? en (1) rad som ska fyllas med m?tningar av niv?n i vattentank 1
h2 = zeros(1, N); %vektor med N nullor p? en (1) rad som ska fyllas med m?tningar av niv?n i vattentank 2
e = zeros(1, N);  % vektor med N nullor p? en (1) rad som ska fyllas med ber?kningar av felv?rdet e
u = zeros(1, N);  % vektor som ska fyllas med ber?kningar av styrv?rdet u
t = (1:N)*dT;     % vektor f?r tiden som en numrering av tidspunkter fr?n 1 till N g?nger samplingstiden
ok=0;             % anv?nds f?r att uppt?cka f?r korta samplingstider
% *************************************************************************************


% ******* DEL D: starta regleringen *******
for k=1:N %slinga kommer att k?ras N-g?ngar, varje g?ng tar exakt Ts-sekunder
    
    start = cputime; %startar en timer f?r att kunna m?ta tiden f?r en loop
    if ok <0 %testar om samplingen ?r f?r kort
        k % sampling time too short!
        disp('samplingstime too short! Increase the value for Ts');
        return
    end
    
    % update timevector
    t(k)=k*dT;
    
    
    % ------------ Read sensor values START ------------
    if(p == 'a0')
        h1(k)= a.analogRead(p); % measure water level in tank 1
        e(k)=r(k)-h1(k); % calculate the error (desired level - actual level)
    else
        h2(k)= a.analogRead(p); % measure water level in tank 2
        e(k)=r(k)-h2(k); % calculate the error (desired level - actual level)
    end
    % ------------ Read sensor values END -----------
    
    
    % ------------ Regulator block START ------------
    switch(regulatorType)
        
        case 'twoStateRegulator'
            if(e(k) >= 0)
                u(k) = 255;
            elseif(e(k) < 0)
                u(k) = 0;
            end
            
        case 'multipleStateRegulator'
            if (e(k) > v/4)
                u(k) = 255;
            elseif(e(k) > 0)
                u(k) = 180;
            elseif(e(k) < 0)
                u(k) = 0;
            end
            
        case 'p_regulator'
            u(k)=e(k); % p-regulator, Kp=1
            
        case 'pid_regulator'
            if k>1 % Vi kan inte anta ett v?rde som inte existerar ?n
                u(k) = K*(e(k) + Ts/Ti*sum(e)+Td*(e(k)-e(k-1))/Ts);
            end
            
        case 'pd_regulator'
            if k>1 % Vi kan inte anta ett v?rde som inte existerar ?n
                u(k) = K*(e(k) + Td *(e(k)-e(k-1))/Ts);
            end
            
        case 'defaultStepAnswer'
            u(k) = 255;
            
    end
    % ------------ Regulator block END ------------
    
    
    u(k) = min(max(0, round(u(k))), 255)*(m/100); % limit the signal between 0-255
    disp("signal " + u(k))
    analogWrite(a,u(k),'DAC0');
    
    
    % ------- online-plot START -------
    figure(1)
    if(p == 'a0')
        plot(t,h1,'k-',t,u,'m:',t,r,'y:');
        xlabel('samplingar (k)');
        title('tank 1, level (h1), signal (u), desired level(r)');
        disp(h1(k));
    else
        plot(t,h2,'k-',t,u,'m:',t,r,'y:');
        xlabel('samplingar (k)');
        title('tank 2, level (h2), signal (u), desired level(r)');
        disp(h2(k));
    end
    legend('h2 ', 'u ', 'r ');
    % ------- online-plot END -------
    
    
    elapsed=cputime-start; % r?knar ?tg?ngen tid i sekunder
    ok=(dT-elapsed);       % sparar tidsmarginalen i ok
    pause(ok);             % pausar resterande samplingstid
    
end % -for (slut av samplingarna)


% DEL E: avsluta experimentet
analogWrite(a,0,'DAC0'); % turn pump off

% plot a final picture
figure(2)
if(p == 'a0')
    plot(t,h1,'k-',t,u,'m:',t,r,'y:');
    xlabel('samplingar (k)')
    ylabel('level (h1), signal (u), desired level (r)')
    title('Tank 1, stegsvar');
    legend('h1 ', 'u ', 'r ')
    y = h1;
else
    plot(t,h2,'k-',t,u,'m:',t,r,'y:');
    xlabel('samplingar (k)')
    ylabel('level (h2), signal (u), desired level (r)')
    title('Tank 2, stegsvar');
    legend('h2 ', 'u ', 'r ')
    y = h2;
end


saveas(figure(2), saveFile);

end

