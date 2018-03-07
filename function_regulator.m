function [y,t] = function_regulator(a, N, dT, bv, p, m, regulatorType, saveFile)

    % ------------ Regulator block START ------------
    switch(regulatorType)
        
        case 'twoStateRegulator'
            [y,u,t] = F211_TwoState(a,N,dT,p,bv,u);
            
        case 'multipleStateRegulator'
            if (e(k) > v/4)
                u(k) = 255;
            elseif(e(k) > 0)
                u(k) = 180;
            elseif(e(k) < 0)
                u(k) = 0;
            end
            
        case 'p_regulator'
            [y,t] = F221_proportionalRegulation(a,N,dT,p,bv, 1);       
        case 'pi_regulator'
            [y,t] = F241_PI_regulation(a,N,dT,p,bv, K, Ti);    
        case 'pid_regulator'
            [y,t] = F251_PID_regulation(a,N,dT,p,bv, K, TI, TD)
        case 'pd_regulator'
            if k>1 % Vi kan inte anta ett v?rde som inte existerar ?n
                u(k) = K*(e(k) + Td *(e(k)-e(k-1))/Ts);
            end
            
        case 'defaultStepAnswer'
            [y,t] = F11_defaultStepAnswer(a,N,dT,p,bv);
            
    end
    % ------------ Regulator block END ------------
    
% plot a final picture
figure(2)
if(p == 'a0')
    plot(t,y,'k-',t,u,'m:',t,r,'y:');
    xlabel('samplingar (k)')
    ylabel('level (h1), signal (u), desired level (r)')
    title('Tank 1, stegsvar');
    legend('h1 ', 'u ', 'r ')
    y = h1;
else
    plot(t,y,'k-',t,u,'m:',t,r,'y:');
    xlabel('samplingar (k)')
    ylabel('level (h2), signal (u), desired level (r)')
    title('Tank 2, stegsvar');
    legend('h2 ', 'u ', 'r ')
    y = h2;
end


saveas(figure(2), saveFile);

end

