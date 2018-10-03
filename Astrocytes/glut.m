function gamma = glut(fr)
    gamma_max = 1; % uM of glutamate
    dt = 1/1000; % s
    spike = rand < fr*dt;
    gamma = rand*spike*gamma_max;
    if gamma == 0 
        gamma = 0.001;
    end
end
