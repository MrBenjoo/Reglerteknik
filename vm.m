function [x,t] = vm(a,N,Ts,bv)
% På/av-regulering av vattenmodellen (nivå h1 och h2), för h1

% DEL A: Beskrivning av de olika variablerna
% utgångsvariablerna (vektorer med n värden):
% h1: nivå (höjd) i behållaren 1, ansluten till 'A0'
% h2: nivå (höjd) i behållaren 2, ansluten till 'A1'
% t: tiden
% u: styrsignal till pumpen

% ingångsvariablerna:
% a: arduino-objekt som fås med funktionen a = arduino_com('COMxx')
% N: antal sampling
% Ts: samplingstiden i sek.
% bv: börvärdet för nivåregleringen (0..100%)

% DEL B: Initialisering av in- och utgångar och interna variabler

% analoga ingångar för mätning av vattennivå: 'A0', 'A1'
% analog utgång för pumpstyrningen, välj analog utgång 'DAC0'

% Bestämning av 100%-nivåvärden i övre och undre vattentanken
H1Max=300; %räkna ut eller mät nivåvärdet för h1 när nivån är maximalt
H2Max=300; %räkna ut eller mät nivåvärdet för h2 när nivån är maximalt

% Räkna ut börvärdet i absoluta tal
r=(bv*H1Max/100)*ones(1,N); %skapar vektor med r i en rad med N element

% DEL C: Skapa och initialisera olika variablerna för att kunna spara mätresultat
% skapa vektorer för att spara mätvärden under experimentet, genom att fylla en vektor med N-nullor
h1 = zeros(1, N); %vektor med N nullor på en (1) rad som ska fyllas med mätningar av nivån i vattentank 1
h2 = zeros(1, N); %vektor med N nullor på en (1) rad som ska fyllas med mätningar av nivån i vattentank 2
e = zeros(1, N); %vektor med N nullor på en (1) rad som ska fyllas med beräkningar av felvärdet e
u = zeros(1, N); %vektor som ska fyllas med beräkningar av styrvärdet u
t = (1:N)*dT; %vektor för tiden som en numrering av tidspunkter från 1 till N gånger samplingstiden
ok=0; %används för att upptäcka för korta samplingstider

% DEL D: starta regleringen 
  
  
  for k=1:N %slinga kommer att köras N-gångar, varje gång tar exakt Ts-sekunder
    
    start = cputime; %startar en timer för att kunna mäta tiden för en loop
    if ok <0 %testar om samplingen är för kort
        k % sampling time too short!
        disp('samplingstiden är för lite! Ök värdet för Ts');
        return
    end
    
    % läs in sensorvärden
    h1(k)= analogRead(a,'A0'); % mät nivån i behållaren 1
    %h2(k)= analogRead(a,'A1'); % mät nivån i behållaren 2 
    
    % beräkna något, t.ex. styrvärdet u(k)
    e(k)=r-h1(k);
    if e(k)>0 
        u(k)=255; %set u till maxvärdet
    else
        u(k)=0;
    end
    
    %skriv ut styrvärdet
    analogWrite(a,u(k),'DAC0'); %styr pumpen med styrvärdet u
        
    
    %online-plot
    plot(t,h1,'k-',t,u,'m:',t,r,'y:');
    
    
    elapsed=cputime-start; %räknar åtgången tid i sekunder
    ok=(dT-elapsed); % sparar tidsmarginalen i ok
    
    pause(ok); %pausar resterande samplingstid

  end % -for
  
  % experimentet är färdig

% DEL E: avsluta experimentet
  analogWrite(a,0,'DAC0'); % stäng av pumpen
  % plotta en fin slutbild, 
  %plot(t,h1,'k-',t,h2,'r--',t,u,'m:');
  plot(t,h1,'k-',t,u,'m:',t,r,'y:');
  xlabel('samplingar')
  ylabel('nivån h1, styrsignal u, börvärde r')
  title('Onoff-reglering vattentankmodel')
  legend('h1 ', 'u ', 'r ')

  x=h1;
end

