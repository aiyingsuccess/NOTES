function xdot = TM(t, x0, spikes)
%TM Tsodyks-Markram model to get neurotransmitter release due to spike
%train
    tau_rec = 100;
    tau_inac = 50;
    U_se = 0.8;
    
    r = x0(1);
    e = x0(2);
    i = 1 - r - e;
    
    inst = round(t);
    f = spikes(inst);
    
    % ODEs
    xdot(1) = i/tau_rec - U_se*r*f;
    xdot(2) = -e/tau_inac + U_se*r*f;
    xdot = xdot';
     
end

