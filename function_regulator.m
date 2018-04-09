function [y,u,t] = function_regulator(a, N, dT, p, bv, m, K, TI, TD, regulatorType, saveFile)


K2 = 0.125;
TI2 = 156;
TD2 = 3.90;
K1 = 3.0;
TI1 = 90;
TD1 =  22.5;
R = 5;

switch(regulatorType)
    case 'twoStateRegulator'
        [y,u,t] = F211_TwoState(a,N,dT,p,bv,saveFile);
    case 'p_regulator'
        [y,u,t] = F221_P_regulation(a,N,dT,p,bv,K,saveFile);
    case 'pi_regulator'
        [y,u,t] = F241_PI_regulation(a,N,dT,p,bv,0.8,4,saveFile);
    case 'pid_regulator'
        [y,u,t] = F251_PID_regulation(a,N,dT,p,bv,K,TI,TD,saveFile);
    case 'defaultStepAnswer'           
        [y,u,t] = F11_defaultStepAnswer(a,N,dT,p,m,saveFile);
    case 'pid_aw_regulator'
        [y,u,t] = F261_PID_antiWindup(a,N,dT,p,bv,K,TI,TD,saveFile);
    case 'pid_kaskad'
        disp('kaskad')                 
        [y,u,t] = F272_kaskadreglering(a,N,dT,bv,K1,TI1,TD1,K2,TI2,TD2,R,saveFile);
end

end

