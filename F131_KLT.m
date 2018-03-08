function [K, L, T] = F131_KLT(a, y, u, tv)

% a: Matlab-Arduino kommunikationsobjekt
% y: stegsvaretsvektor fr?n stegsvarsexperimentet med tillr?ckligt m?nga
% samples (ska vara konstanta v?rdena i slutet) som b?rjar vid f?rsta
% sample. Enligt labbhanledningen ska variabeln 'y' kallas 'x' men vi
% kallar den f?r 'y'.
% u: V?rden av stegets h?jd som anv?ndes f?r stegsvaret (= styrsignal till motorn), satt vid f?rsta sample, (antagligen mellan 0 och 255)
% tv: tidsvektor med tiden fr?n starten av stegsvarsexperimentet i sekunder

indexOfChange = 0;
indexStartRegulation = 0;
N = length(tv);

%Finding the index where the regulation starts showing effect
for k=2:N-1
   if(y(k)*1.04 < y(k+1)) % Motsvarar L (d?dtid)
       indexOfChange = k;
   end
end

L = indexOfChange

%Highest value stored at index M
%Position I of the highest value M
[M,I] = max(y);

T63 = M*0.63; %antal samplingar
T = T63 - L %antal sekunder

K = (y(I))/(u(I))

end

