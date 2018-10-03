function  [o1, o2, o3] = solv_diff(ii, G, neighbors, time, CaC, h, IC, options, glu_mat, syn)%, DC_i_mat)
%solv_diff_glu This function solves the ODEs for every grid cell of the
%matrices, depending on its tag. It works with different input(glu) in each synapse 

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
%   
%   It gets a matrix of glutamate inputs(glu_mat), where each row corresponds to the input of a
%   single synapse. The rows are ordered in the order given by the column
%   vector syn, which describes the synapses that need to be active. 

        r = neighbors(ii,2);
        c = neighbors(ii,3);
        if G(r,c) > 3.7
            if ismember(G(r,c), syn) % If the tag of the specific synapse belongs to the vector syn, describing the active synapses, then get its input from the matrix of inputs
                deik = G(r,c);
                syn_no = find(syn==deik);
                glu = glu_mat(syn_no, :);
            else
                glu = 0.001*ones(1,length(glu_mat)); % otherwise, feed it with idle input
            end
            [t,x_sim] = ode45(@(t,x0)ODE_IP3_prod(t, x0, glu),time,[CaC(r,c) h(r,c) IC(r,c)],options);
            CaC(r,c) = x_sim(end, 1);         
            h(r,c) = x_sim(end, 2); 
            IC(r,c) = x_sim(end, 3);
        elseif G(r,c) > 3
            glu = glu_mat(1,:);
            [t,x_sim] = ode45(@(t,x0)ODE_IP3_prod(t, x0, 0.001*ones(size(glu))),time,[CaC(r,c) h(r,c) IC(r,c)],options);
            CaC(r,c) = x_sim(end, 1);         
            h(r,c) = x_sim(end, 2); 
            IC(r,c) = x_sim(end, 3);
        elseif G(r,c) == 2
            glu = glu_mat(1,:);
            [t,x_sim] = ode45(@(t,x0)ODE_IP3_ER(t, x0, glu),time,[CaC(r,c) h(r,c) IC(r,c)],options);
            CaC(r,c) = x_sim(end, 1);         
            h(r,c) = x_sim(end, 2); 
            IC(r,c) = x_sim(end, 3);
        elseif G(r,c) == 1
            glu = glu_mat(1,:);
            [t,x_sim] = ode45(@(t,x0)ODE_IP3_ER_full(t, x0, glu),time,[CaC(r,c) h(r,c) IC(r,c)],options);
            CaC(r,c) = x_sim(end, 1);         
            h(r,c) = x_sim(end, 2); 
            IC(r,c) = x_sim(end, 3);
        end
        o1 = CaC(r,c);
        o2 = h(r,c);
        o3 = IC(r,c);
end

