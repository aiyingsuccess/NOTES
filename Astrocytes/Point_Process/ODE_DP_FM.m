function xdot = ODE_DP_FM(t, x0, glu)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    C = x0(1);
    h = x0(2);
    I = x0(3);
    
    r_C = 6;
    r_L = 0.11;
    C_0 = 2;
    c_1 = 0.185;
    v_ER = 0.9;
    K_ER = 0.1;  % for AM, 0.05 for FM
    d_1 = 0.13;
    d_2 = 1.049;
    d_3 = 0.9434;
    d_5 = 0.08234;
    a_2 = 0.2;

    v_delta = 0.02;  % for AM, 0.05 for FM
    K_PLC_delta = 0.1;
    k_delta = 1.5;

    r_5P = 0.04;  % for AM, 0.05 for FM
    v_3K = 2;
    K_D = 0.7;
    K_3 = 1;

    v_beta = 0.2;  % for AM, 0.5 for FM
    K_R = 1.3;
    K_P = 10;
    K_pi = 0.6;
    
    inst = round(t);
    GAMMA = glu(inst);
%     if t>20 && t<100
%         GAMMA = 6;
%     elseif t>180 && t<260
%         GAMMA = 6;
%     else 
%         GAMMA = 0.002;
%     end
    % Terms for the Ca equation
    J_pump = v_ER*Hill(C, 2.0, K_ER);
    
    J_leak = r_L*(C_0 - (1 + c_1)*C);
    
    m_inf = Hill(I, 1.0, d_1);
    
    n_inf = Hill(C, 1.0,  d_5);
    
    J_chan = r_C*power(m_inf, 3.0)*power(n_inf, 3.0)*power(h, 3.0)*(C_0 - (1 + c_1)*C);
    
    % Terms for the h equation
    Q_2 = d_2*(I + d_1)/(I + d_3);

    tau_h = 1./(a_2*(Q_2 + C));

    h_inf = Q_2/(Q_2 + C);
    
    % Terms for the IP3 equation
    K_beta = K_R*(1+(K_P/K_R)*Hill(C, 1.0, K_pi));
    PLC_beta = v_beta *Hill(GAMMA, 0.7, K_beta);

    PLC_delta = (v_delta/(1 + I./k_delta))*Hill(C, 2.0, K_PLC_delta);

    ThreeK = - v_3K*Hill(C, 4.0, K_D)*Hill(I, 1.0, K_3);

    FiveP = - r_5P*I;
    
    % ODEs
    xdot(1) = J_chan + J_leak - J_pump;
    xdot(2) = (h_inf - h) / tau_h;
    xdot(3) = PLC_beta + PLC_delta + ThreeK + FiveP;
    xdot = xdot';
    
end

