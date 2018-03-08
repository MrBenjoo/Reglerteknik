function [y,u,t] = function_regulator(a, N, dT, bv, p, m, regulatorType, saveFile)

switch(regulatorType)
    case 'twoStateRegulator'
        [y,u,t] = F211_TwoState(a,N,dT,p,m,bv, saveFile);
    case 'p_regulator'
        [y,u,t] = F221_proportionalRegulation(a,N,dT,p,m,bv,1,saveFile);
    case 'pi_regulator'
        [y,u,t] = F241_PI_regulation(a,N,dT,p,bv,K,Ti,saveFile);
    case 'pid_regulator'
        [y,u,t] = F251_PID_regulation(a,N,dT,p,bv,K,TI,TD,saveFile);
    case 'defaultStepAnswer'
        [y,u,t] = F11_defaultStepAnswer(a,N,dT,p,bv,m,saveFile);
end

end

