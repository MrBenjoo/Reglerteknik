function [x,t] = vm(a,N,Ts,bv)
% P�/av-regulering av vattenmodellen (niv� h1 och h2), f�r h1

% DEL A: Beskrivning av de olika variablerna
% utg�ngsvariablerna (vektorer med n v�rden):
% h1: niv� (h�jd) i beh�llaren 1, ansluten till 'A0'
% h2: niv� (h�jd) i beh�llaren 2, ansluten till 'A1'
% t: tiden
% u: styrsignal till pumpen

% ing�ngsvariablerna:
% a: arduino-objekt som f�s med funktionen a = arduino_com('COMxx')
% N: antal sampling
% Ts: samplingstiden i sek.
% bv: b�rv�rdet f�r niv�regleringen (0..100%)

% DEL B: Initialisering av in- och utg�ngar och interna variabler

% analoga ing�ngar f�r m�tning av vattenniv�: 'A0', 'A1'
% analog utg�ng f�r pumpstyrningen, v�lj analog utg�ng 'DAC0'

% Best�mning av 100%-niv�v�rden i �vre och undre vattentanken
H1Max=300; %r�kna ut eller m�t niv�v�rdet f�r h1 n�r niv�n �r maximalt
H2Max=300; %r�kna ut eller m�t niv�v�rdet f�r h2 n�r niv�n �r maximalt

% R�kna ut b�rv�rdet i absoluta tal
r=(bv*H1Max/100)*ones(1,N); %skapar vektor med r i en rad med N element

% DEL C: Skapa och initialisera olika variablerna f�r att kunna spara m�tresultat
% skapa vektorer f�r att spara m�tv�rden under experimentet, genom att fylla en vektor med N-nullor
h1 = zeros(1, N); %vektor med N nullor p� en (1) rad som ska fyllas med m�tningar av niv�n i vattentank 1
h2 = zeros(1, N); %vektor med N nullor p� en (1) rad som ska fyllas med m�tningar av niv�n i vattentank 2
e = zeros(1, N); %vektor med N nullor p� en (1) rad som ska fyllas med ber�kningar av felv�rdet e
u = zeros(1, N); %vektor som ska fyllas med ber�kningar av styrv�rdet u
t = (1:N)*dT; %vektor f�r tiden som en numrering av tidspunkter fr�n 1 till N g�nger samplingstiden
ok=0; %anv�nds f�r att uppt�cka f�r korta samplingstider

% DEL D: starta regleringen 
  
  
  for k=1:N %slinga kommer att k�ras N-g�ngar, varje g�ng tar exakt Ts-sekunder
    
    start = cputime; %startar en timer f�r att kunna m�ta tiden f�r en loop
    if ok <0 %testar om samplingen �r f�r kort
        k % sampling time too short!
        disp('samplingstiden �r f�r lite! �k v�rdet f�r Ts');
        return
    end
    
    % l�s in sensorv�rden
    h1(k)= analogRead(a,'A0'); % m�t niv�n i beh�llaren 1
    %h2(k)= analogRead(a,'A1'); % m�t niv�n i beh�llaren 2 
    
    % ber�kna n�got, t.ex. styrv�rdet u(k)
    e(k)=r-h1(k);
    if e(k)>0 
        u(k)=255; %set u till maxv�rdet
    else
        u(k)=0;
    end
    
    %skriv ut styrv�rdet
    analogWrite(a,u(k),'DAC0'); %styr pumpen med styrv�rdet u
        
    
    %online-plot
    plot(t,h1,'k-',t,u,'m:',t,r,'y:');
    
    
    elapsed=cputime-start; %r�knar �tg�ngen tid i sekunder
    ok=(dT-elapsed); % sparar tidsmarginalen i ok
    
    pause(ok); %pausar resterande samplingstid

  end % -for
  
  % experimentet �r f�rdig

% DEL E: avsluta experimentet
  analogWrite(a,0,'DAC0'); % st�ng av pumpen
  % plotta en fin slutbild, 
  %plot(t,h1,'k-',t,h2,'r--',t,u,'m:');
  plot(t,h1,'k-',t,u,'m:',t,r,'y:');
  xlabel('samplingar')
  ylabel('niv�n h1, styrsignal u, b�rv�rde r')
  title('Onoff-reglering vattentankmodel')
  legend('h1 ', 'u ', 'r ')

  x=h1;
end

