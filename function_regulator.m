function [y,t] = function_regulator(a,N,Ts,bv,hx,regulatorType,savefile)
% P�/av-regulering av vattenmodellen (niv� h1 och h2), f�r h1

% ******* DEL A: Beskrivning av de olika variablerna *******
% utg�ngsvariablerna (vektorer med n v�rden):
%   - y: niv� (h�jd) i beh�llaren x, anges i steg_svar('A0' = tank 1, 'A1' = tank 2)
%   - t: tiden
%   - u: styrsignal till pumpen

% ing�ngsvariablerna:
%   - a: arduino-objekt som f�s med funktionen a = arduino_com('COMxx')
%   - N: antal samplingar
%   - Ts: samplingstiden i sek.
%   - bv: b�rv�rdet f�r niv�regleringen (0..100%)
%   - hx: intresserade av �rv�rdet f�r tanken x som ska l�sas av med analogRead
% ********************************************************



% ******* DEL B: Initialisering av in- och utg�ngar och interna variabler *******
% analoga ing�ngar f�r m�tning av vattenniv�: 'A0', 'A1'
% analog utg�ng f�r pumpstyrningen, v�lj analog utg�ng 'DAC0'
% R�kna ut b�rv�rdet i absoluta tal
r=(bv*H1Max/100)*ones(1,N); % skapar vektor med r i en rad med N element
% *******************************************************************************



% *** DEL C: Skapa och initialisera olika variabler f�r att kunna spara m�tresultat ***
% skapa vektorer f�r att spara m�tv�rden under experimentet, genom att fylla en vektor med N-nullor
y = zeros(1, N);  % vektor med N nullor p� en (1) rad som ska fyllas med m�tningar av niv�n i vattentank x (anges i steg_svar)
e = zeros(1, N);  % vektor med N nullor p� en (1) rad som ska fyllas med ber�kningar av felv�rdet e
u = zeros(1, N);  % vektor som ska fyllas med ber�kningar av styrv�rdet u
t = (1:N)*dT;     % vektor f�r tiden som en numrering av tidspunkter fr�n 1 till N g�nger samplingstiden
ok=0;             % anv�nds f�r att uppt�cka f�r korta samplingstider
% *************************************************************************************



% ******* DEL D: starta regleringen *******
for k=1:N %slinga kommer att k�ras N-g�ngar, varje g�ng tar exakt Ts-sekunder
    
    start = cputime; %startar en timer f�r att kunna m�ta tiden f�r en loop
    if ok <0 %testar om samplingen �r f�r kort
        k % sampling time too short!
        disp('samplingstiden �r f�r lite! �k v�rdet f�r Ts');
        return
    end
    
    % uppdatera tidsvektorn
    t(k)=k*dT;
    
    % l�s in sensorv�rden
    y(k)= a.analogRead(hx); % m�t niv�n i beh�llaren hx
    
    e(k)=r-y(k); % ber�kna felv�rdet som skillnaden mellan b�rv�rdet och �rv�rdet
    
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
            if k>1 % Vi kan inte anta ett v�rde som inte existerar �n
                u(k) = K*(e(k) + Ts/Ti*sum(e)+Td*(e(k)-e(k-1))/Ts);
            end
            
        case 'pd_regulator'
            if k>1 % Vi kan inte anta ett v�rde som inte existerar �n
                u(k) = K*(e(k) + Td *(e(k)-e(k-1))/Ts);
            end
            
        case 'defaultStepAnswer'
            u(k) = 45;
            
    end
    % ------------ Regulator block END ------------
    
    
    u(k) = min(max(0, round(u(k))), 255); % begr�nsa styrv�rdet mellan 0-255
    analogWrite(a,u(k),'DAC0');           % skriv ut styrv�rdet
    
 
    % ------- online-plot START -------
    figure(1)
    plot(t,y,'k-',t,u,'m:',t,r,'y:');
    xlabel('samplingar (k)');
    if(hx == 'a0')
        title('Beh�llare 1, �rv�rdet (y), styrv�rdet (u), b�rv�rdet (r)');
    else
        title('Beh�llare 2, �rv�rdet (y), styrv�rdet (u), b�rv�rdet (r)');
    end
    legend('y ', 'u ', 'r ');
    % ------- online-plot END -------
    
    
    elapsed=cputime-start; % r�knar �tg�ngen tid i sekunder
    ok=(dT-elapsed);       % sparar tidsmarginalen i ok
    pause(ok);             % pausar resterande samplingstid
    
end % -for (slut av samplingarna)


% DEL E: avsluta experimentet
analogWrite(a,0,'DAC0'); % st�ng av pumpen


% plotta en fin slutbild,
plot(t,y,'k-',t,u,'m:',t,r,'y:');

xlabel('samplingar (k)')
ylabel('niv� (y), styrsignal (u), b�rv�rde (r)')

if(hx == 'a0')
   title('Beh�llare 1, Onoff-reglering vattentankmodel');
else
   title('Beh�llare 2, Onoff-reglering vattentankmodel');
end

legend('y ', 'u ', 'r ')
saveas(figure(2), savefile);

end

