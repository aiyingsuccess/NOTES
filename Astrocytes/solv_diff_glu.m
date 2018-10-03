function  [o1, o2, o3] = solv_diff_glu(ii, G, neighbors, time, CaC, h, IC, options, glu)
%solv_diff_glu This function solves the ODEs for every grid cell of the
%matrices, depending on its tag. It works when the same input(glu) is fed to all synapses 

%   This function solves the ODEs for every grid cell of the
%   matrices, depending on its tag. 
%
%   Tag >3.1 indicates perisynaptic astrocytic process and demands IP3 production (solve ODE_IP3_prod)  

%   Tag 3.1 indicates passive process and demands IP3 and Ca decay, without any production (solve ODE_IP3 production without stimulus) 

%   Tag 2 indicates IP3-sensitive ER and demands IP3 and Ca decay, but also
%   Ca production from the IP3-sensitive compartment. (solve ODE_IP3_ER)

%   Tag 1 indicates Ryanodine-sensitive Er and demands IP3 and Ca decay,
%   but also Ca production from both IP3-sensitive and Ry-sensitive ER
%   (solve ODE_IP3_ER_full)

        r = neighbors(ii,2);
        c = neighbors(ii,3);
        if G(r,c) >3.1
            [t,x_sim] = ode45(@(t,x0)ODE_IP3_prod(t, x0, glu),time,[CaC(r,c) h(r,c) IC(r,c)],options); % solve ODEs for the grid cell
            CaC(r,c) = x_sim(end, 1); % save Ca results in Ca matrix         
            h(r,c) = x_sim(end, 2); % save h results in Ca matrix
            IC(r,c) = x_sim(end, 3); % save IP3 results in Ca matrix
        elseif G(r,c) == 3.1
            [t,x_sim] = ode45(@(t,x0)ODE_IP3_prod(t, x0, 0.001*ones(size(glu))),time,[CaC(r,c) h(r,c) IC(r,c)],options);
            CaC(r,c) = x_sim(end, 1);         
            h(r,c) = x_sim(end, 2); 
            IC(r,c) = x_sim(end, 3);    
        elseif G(r,c) == 3
            [t,x_sim] = ode45(@(t,x0)ODE_IP3_ER(t, x0, glu),time,[CaC(r,c) h(r,c) IC(r,c)],options);
            CaC(r,c) = x_sim(end, 1);         
            h(r,c) = x_sim(end, 2); 
            IC(r,c) = x_sim(end, 3);
        elseif G(r,c) == 2
            [t,x_sim] = ode45(@(t,x0)ODE_IP3_ER(t, x0, glu),time,[CaC(r,c) h(r,c) IC(r,c)],options);
            CaC(r,c) = x_sim(end, 1);         
            h(r,c) = x_sim(end, 2); 
            IC(r,c) = x_sim(end, 3);
        elseif G(r,c) == 1
            [t,x_sim] = ode45(@(t,x0)ODE_IP3_ER_full(t, x0, glu),time,[CaC(r,c) h(r,c) IC(r,c)],options);
            CaC(r,c) = x_sim(end, 1);         
            h(r,c) = x_sim(end, 2); 
            IC(r,c) = x_sim(end, 3);
        end
        o1 = CaC(r,c); % Return matrices
        o2 = h(r,c);
        o3 = IC(r,c);
end

