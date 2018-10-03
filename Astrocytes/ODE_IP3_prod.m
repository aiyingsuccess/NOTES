function xdot = ODE_IP3_prod(t, x0, glu)
%ODE_IP3_prod The function that computes the ODES for the perisynaptic
%astrocytic processes, where IP3 is produced

%   The function solves the ODEs for IP3 production. The terms of each
%   equation are modified depending on what functions the grid cell is
%   endowed with.
    C = x0(1);
    h = x0(2);
    I = x0(3);
    
    v_ER = 0.9/1000; % was 0.5
    K_ER = 0.05;  % for AM, 0.05 for FM
    d_1 = 0.13;
    d_2 = 1.049;
    d_3 = 0.9434;
    d_5 = 0.08234;
    a_2 = 0.2/1000;

%     v_delta = 0.02/1000;  % for AM, 0.05 for FM
    v_delta = 0.05/1000;
    K_PLC_delta = 0.1;
    k_delta = 1.5;

    r_5P = 0.05/1000;  % for AM, 0.05 for FM
    v_3K = 1.5/1000;
    K_D = 0.7;
    K_3 = 1;

%     v_beta = 15/1000;  % for AM, 0.5 for FM
    v_beta = 2.5/1000;
    K_R = 1.3;
    K_P = 10;
    K_pi = 0.6;
    
    inst = round(t);
    GAMMA = glu(inst/0.5);
   
%     % Terms for the Ca equation
    J_pump = v_ER*Hill(C, 2.0, K_ER);
    
%     J_leak = r_L*(C_0 - (1 + c_1)*C);
    
%     m_inf = Hill(I, 1.0, d_1);
%     
%     n_inf = Hill(C, 1.0,  d_5);
    
%     J_chan = r_C*power(m_inf, 3.0)*power(n_inf, 3.0)*power(h, 3.0)*(C_0 - (1 + c_1)*C);
    
%     % Terms for the h equation
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
%     xdot(1) = J_chan + J_leak - J_pump;
    xdot(1) = - J_pump;
%     xdot(1) = 0;
    xdot(2) = (h_inf - h) / tau_h;
%     xdot(2) = 0;
    xdot(3) = PLC_beta + PLC_delta + ThreeK + FiveP;
    xdot = xdot';
    
     
end
