dur = 60000;
R = 0.6; % [GOhm]
C = 100; % [pF]
tau_LIF = R*C; 
v_thr = -40;
v_reset = -65;
I_stim = 7*SIC;
v(1) = v_reset;

for i =1:1:dur
    v(i+1) = v(i) + (1/tau_LIF)*(v_reset - v(i) + R*I_stim(i));
    
    if v(i+1) >= v_thr
        v(i+1) = v_reset;
    end
end

plot(v)

