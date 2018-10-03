function glu = real_glu(dur, fr, dur_act, interv, activ_ratio)
%real_glu This function produces glutamate stimulus using the
%Tsodyks-Markram model of facilitation-depression and translating it to
%glutamate production

    dt = 1/1000; % Time step for spike train measured in seconds

    spikes = []; % % Make spike train of presynaptic neuron
    for j = 1:dur_act/interv
        temp = zeros(1,interv);
        for i =1:interv*activ_ratio
            temp(i) = rand < fr*dt;
        end
        spikes = [spikes,temp];
    end

    dt = 0.5;
    time = [0.5:dt:dur]';


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x0(1) = 0.7;
    x0(2) = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    options = odeset('AbsTol', 10^-6, 'RelTol', 10^-6, 'MaxStep', 0.5);
%     tic
    [t,x_sim] = ode45(@(t,x0)TM(t, x0, spikes),time,x0,options); % Use Tsodyks-Markram model to get neurotranmitter amoun released due to the spike train
%     toc
    
    r = x_sim(:,1);
    e = x_sim(:,2);
    i = 1 - r - e;

    A_se = 1.5; 
    glu = A_se*e;
    index = find(glu<0.001);
    glu(index) = 0.001;
end