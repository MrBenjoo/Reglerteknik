function [K, L, T] = F131_KLT(a, y, u, tv)

% a: Matlab-Arduino kommunikationsobjekt
% y: stegsvaretsvektor fr?n stegsvarsexperimentet med tillr?ckligt m?nga
% samples (ska vara konstanta v?rdena i slutet) som b?rjar vid f?rsta
% sample. Enligt labbhanledningen ska variabeln 'y' kallas 'x' men vi
% kallar den f?r 'y'.
% u: V?rden av stegets h?jd som anv?ndes f?r stegsvaret (= styrsignal till motorn), satt vid f?rsta sample, (antagligen mellan 0 och 255)
% tv: tidsvektor med tiden fr?n starten av stegsvarsexperimentet i sekunder


load('filtrerad_B53_PID_Astrom_Hagglund.mat')

indexOfChange = 0;
indexStartRegulation = 0;
N = length(tv);

%Finding the index where the regulation starts showing effect
baselineValue = sum(u(1:10))/10;
for k=1:N
   if(u(k)>baselineValue+10) % Motsvarar L (d?dtid)
       indexOfChange = k;
       break;
   end
end

%Finding the index where the regualtion is activated, signal is starting to
%increase
for k=1:N
   if(u(k)>0)
       indexStartRegulation = k;
       break;
   end
end

L = indexOfChange - indexStartRegulation;

%Highest value stored at index M
%Position I of the highest value M
[M,I] = max(y);

T63 = M*0.63; %antal samplingar
T = T63 - L; %antal sekunder

K = (y(I)-baselineValue)/u(I);

end

