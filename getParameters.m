function [K,TI,TD] = getParameters(method)

switch(method)
    case 'ziegler'
        K = 3.0;
        TI = 90;
        TD = 22.5;
    case 'lambdaT'
        K = 0.117;
        TI = 146;
        TD = 1.485;
    case 'lambda2T'
        K = 0.059;
        TI = 146;
        TD = 1.485;
    case 'amigo'
        K = 2.56;
        TI = 20.08;
        TD = 1.49;
end

end

