function [y,u,t] = function_regulator(a, N, dT, bv, p, m, regulatorType, saveFile)

    % ------------ Regulator block START ------------
    switch(regulatorType)
        
        case 'twoStateRegulator'
            [y,u,t] = F211_TwoState(a,N,dT,p,m,bv, saveFile);
            
        case 'multipleStateRegulator'
            if (e(k) > v/4)
                u(k) = 255;
            elseif(e(k) > 0)
                u(k) = 180;
            elseif(e(k) < 0)
                u(k) = 0;
            end
            
        case 'p_regulator'
            [y,u,t] = F221_proportionalRegulation(a,N,dT,p,m,bv,1,saveFile);       
        case 'pi_regulator'
            [y,u,t] = F241_PI_regulation(a,N,dT,p,bv, K, Ti,saveFile);    
        case 'pid_regulator'
            [y,u,t] = F251_PID_regulation(a,N,dT,p,bv, K, TI, TD,saveFile);
        case 'pd_regulator'
            if k>1 % Vi kan inte anta ett v?rde som inte existerar ?n
                u(k) = K*(e(k) + Td *(e(k)-e(k-1))/Ts);
            end
            
        case 'defaultStepAnswer'
            [y,u,t] = F11_defaultStepAnswer(a,N,dT,p,bv,m,saveFile);
            
    end
    % ------------ Regulator block END ------------
    
end

