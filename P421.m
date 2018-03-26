function [] = P421(y,u,t,togglerP421, saveFileFigure)
%P421 Summary of this function goes here
%   Detailed explanation goes here
load komplettering_labb1504e
switch(togglerP421)
    %R1 output
    case 'R1'
        R1_y_zn = y;
        R1_u_zn = u;
        R1_t_zn = t;
        R1_plot = saveFileFigure;
        
    case 'R2'
        %R2 output
        R2_y_lambdaT = y;
        R2_u_lambdaT = u;
        R2_t_lambdaT = t;
        R2_plot = saveFileFigure;
        
    case 'R3'
        %R3 output
        R3_y_lambda2T  = y;
        R3_u_lambda2T  = u;
        R3_t_lambda2T  = t;
        R3_plot = saveFileFigure;
        
    case 'R4'
        %R4 output
        R4_y_amigo = y;
        R4_u_amigo = u;
        R4_t_amigo = t;
        R4_plot = saveFileFigure;
        
    case 'R1_aw'
        %R1 output
        R1_y_aw = y;
        R1_u_aw = u;
        R1_t_aw = t;
        R1_plot = saveFileFigure;
        
    case 'R2_aw'
        %R2 output
        R2_y_aw = y;
        R2_u_aw = u;
        R2_t_aw = t;
        R2_plot = saveFileFigure;
        
    case 'R3_aw'
        %R3 output
        R3_y_aw  = y;
        R3_u_aw  = u;
        R3_t_aw = t;
        R3_plot = saveFileFigure;
        
    case 'R4_aw'
        %R4 output
        R4_y_aw = y;
        R4_u_aw = u;
        R4_t_aw = t;
        R4_plot = saveFileFigure;
        
    case 'R1_PID_40percent_zn'
        %R1 output
        R1_y_40percent = y;
        R1_u_40percent  = u;
        R1_t_40percent  = t;
        R1_plot_40percent  = saveFileFigure;
        
    case 'R2_PID_40percent_lambdaT'
        %R2 output
        R2_y_40percent   = y;
        R2_u_40percent   = u;
        R2_t_40percent   = t;
        R2_plot_40percent  = saveFileFigure;
        
    case 'R3_PID_40percent_lambda2T'
        %R3 output
        R3_y_40percent = y;
        R3_u_40percent = u;
        R3_t_40percent = t;
        R3_plot_40percent    = saveFileFigure;
        
    case 'R4_PID_40percent_amigo'
        %R4 output
        R4_y_40percent = y;
        R4_u_40percent = u;
        R4_t_40percent = t;
        R4_plot_40percent = saveFileFigure;
        
        
    case 'R1_PID_aw_40percent_zn'
        %R1 output
        R1_y_aw_40percent = y;
        R1_u_aw_40percent  = u;
        R1_t_aw_40percent  = t;
        R1_plot_aw_40percent  = saveFileFigure;
        
    case 'R2_PID_aw_40percent_lambdaT'
        %R2 output
        R2_y_aw_40percent   = y;
        R2_u_aw_40percent   = u;
        R2_t_aw_40percent   = t;
        R2_plot_aw_40percent  = saveFileFigure;
        
    case 'R3_PID_aw_40percent_lambda2T'
        %R3 output
        R3_y_aw_40percent = y;
        R3_u_aw_40percent = u;
        R3_t_aw_40percent = t;
        R3_plot_aw_40percent    = saveFileFigure;
        
    case 'R4_PID_aw_40percent_amigo'
        %R4 output
        R4_y_aw_40percent = y;
        R4_u_aw_40percent = u;
        R4_t_aw_40percent = t;
        R4_plot_aw_40percent = saveFileFigure;
end
clear toggler togglerP421 togglerType Ka Ks L T Td Ti LAMBDA TD saveFileFigure loadFileVariables y u t m ON OFF p1 p2 regulatorType K T0D TI tank1 tank2 timeCalculations tumRegelMetoder saveFileVariables dT bv bv1 bv2 KLTMethod N P421_toggler regulator
load komplettering_labb1504e
save komplettering_labb1504e
end

