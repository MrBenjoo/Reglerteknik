function [y,u,t] = function_regulator(a, N, dT, bv, p, m, regulatorType, saveFile)

switch(regulatorType)
    case 'twoStateRegulator'
        [y,u,t] = F211_TwoState(a,N,dT,p,m,bv, saveFile);
    case 'p_regulator'
        [y,u,t] = F221_proportionalRegulation(a,N,dT,p,bv,15,saveFile);
    case 'pi_regulator'
        [y,u,t] = F241_PI_regulation(a,N,dT,p,bv,0.8,4,saveFile);
    case 'pid_regulator'%argument -> (a,N,dT,p,bv,K,TI,TD,saveFile)
        [y,u,t] = F251_PID_regulation(a,N,dT,p,bv,K,10^30,0,saveFile); 
    case 'defaultStepAnswer'
        [y,u,t] = F11_defaultStepAnswer(a,N,dT,p,bv,m,saveFile);
end

end

