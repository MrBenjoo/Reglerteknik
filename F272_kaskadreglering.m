function [y,t] = F261_PID_antiWindup(a,N,dT,bv, K1, TI1, TD1, K2, TI2, TD2, R)

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
y1 = zeros(1, N); %vektor med N nullor p? en (1) rad som ska fyllas med m?tningar av niv?n i vattentank 1 och 2
e1 = zeros(1, N);  % vektor med N nullor p? en (1) rad som ska fyllas med ber?kningar av felv?rdet e
u1 = zeros(1, N);  % vektor som ska fyllas med ber?kningar av styrv?rdet u
y2 = zeros(1, N); %vektor med N nullor p? en (1) rad som ska fyllas med m?tningar av niv?n i vattentank 1 och 2
e2 = zeros(1, N);  % vektor med N nullor p? en (1) rad som ska fyllas med ber?kningar av felv?rdet e
u2 = zeros(1, N);  % vektor som ska fyllas med ber?kningar av styrv?rdet u
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
    
    
    
    if(mod(k-1, R) == 0)
        analogWrite(a,u1(k),'DAC0');
        %In till R1 yttre kretsen, undre vattentanken
        y1(k) = a.analogRead(1);
        
        e1(k) = r(k)-y1(k);
        u1(k) = K1*(e1(k) + Ts/TI1*sum(e)+TD1*(e1(k)-e(k-1))/Ts);
    end
    
    %In till R2 inre kretsen, ?vre vattentanken
    y2(k) = a.analogRead(0);
    
    e2(k) = u1(k)-y2(k);
    u2(k) = K2*(e2(k) + Ts/TI2*sum(e)+TD2*(e2(k)-e2(k-1))/Ts);
    
    u2(k) = min(max(0, round(u2(k))), 255)*(m/100); % limit the signal between 0-255
    disp("signal " + u(k))
    analogWrite(a,u2(k),'DAC0');
    
    
    % ------------ Read sensor values END -----------
    
    
    u1(k) = min(max(0, round(u1(k))), 255)*(m/100); % limit the signal between 0-255
    disp("signal " + u(k))
    analogWrite(a,u(k),'DAC0');
    
    % ------- online-plot START -------
    figure(1)
    plot(t,y,'k-',t,u,'m:',t,r,'y:');
    xlabel('samplingar (k)');
    if(p == 'a0')
        title('tank 1, level (h1), signal (u), desired level(r)');
    else
        title('tank 2, level (h2), signal (u), desired level(r)');
    end
    disp(y(k));
    legend('y ', 'u ', 'r ');
    % ------- online-plot END -------
    
    
    elapsed=cputime-start; % r?knar ?tg?ngen tid i sekunder
    ok=(dT-elapsed);       % sparar tidsmarginalen i ok
    pause(ok);             % pausar resterande samplingstid
    
end % -for (slut av samplingarna)


% DEL E: avsluta experimentet
analogWrite(a,0,'DAC0'); % turn pump off

end