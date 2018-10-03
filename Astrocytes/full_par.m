clear all
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dur = 60000; % Time parameters
dt = 0.5;
% time_glu = [0.5:dt:dur]';
% time = time(1:length(time)-1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x0(1) = 1e-8; % Initial values
x0(1)=0.0698025; 
x0(2)=0.793086;
x0(3)=0.0148465;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
G = dlmread('star_geometry1.txt'); % Load the astrocyte geometry from the txt file
index = find(G==0);
G(index) = -10000; % Set background to -10000 for visualization purposes

% G = G(76:299, 83:305);   % Keep the part of the cell until primary branch
% % G(:,1:80) = 0;
% % G(:,142:end) = 0;
% % G(157:end, 81:144) = 0; 
% % G(1:144, 157:end) = 0;
% % G(56:104, 118:end) = 0;
% % G(72:102, 157:end) = 0;
% 
% 
% 
% syn = [113;121;114;106;96;82;95; % Numbering of the synapses in a clockwise order in microdomains following clockwise oder
%        86;78;66;50;38;49;65;
%        60;44;34;27;33;43;59;
%        64;48;37;47;63;77;85;
%        94;81;93;105;111;119;112;
%        120;125;127;135;143;136;128;
%        131;139;145;149;146;140;132;
%        ];



% G(1:77, :) = 0;
% G(157:end, 1:144) = 0;
% G(:, 1:105) = 0;
% G(75:97, 105:144) = 0;
% G(124:157, 106:114) = 0;
% G(76:84, 162:171) = 0;
% G(:, 1:106) = 0;
% G(143:end, 145:end) = 0;
% G(115:160, 124:151) = 0;

% G = triu(G, -45);
% G = tril(G, 50);

% G(148:end, 145:end) = 0;
G = G(96:181, 106:189); % 96:160, 106:169    % Keep the part of the cell until secondary branch
syn = [64];%;48;37;47;63;77;85]; % Specify the active synapses (see solv_diff)
G(59:end,1:29) = 0;
G(65:end, 1:35) = 0;
G(1:37, 64:end) = 0;
G(1:16, 57:end) = 0;
G(37:end, 83:end) = 0;
G = G(1:66, 2:66);
index = find(G==0);
G(index) = -10000;

%%%%%%%%%%%%%%%%%%%% Activation of the three upper synapses(when you have only one microdomain)
% L = G(28:64,:);
% deik = find(L==4);
% L(deik) = 3;
% G(28:64,:) = L; 
%%%%%%%%%%%%%%%%%%%% % Activation of 4 below diagonal synapses(when you have only one microdomain)
% U = triu(G, 6); 
% G_pr = tril(G, 5); 
% % imagesc(L)
% deik = find(U==4);
% U(deik) = 3;
% G_pr = G_pr + U;
% G = G_pr;
%%%%%%%%%%%%%%%%%%%%
meg = size(G);

indices = find(G > 0); % Find non-zero elements of Geometry Matrix to
                        % reduce complexity, we care only for the 
                        % astrocyte, not its background
H = G; 
H(indices) = 1; % 0/1 matrix with 0s in background cells and 1s in astrocyte cells
CaC = H*x0(1); % Initialize Ca matrix
h= H*x0(2); % Initialize h(gate-keeper variable) matrix
IC = H*x0(3); % Initialize IP3 matrix

index = find(G==0);
G(index) = -10000;
CaC(index) = 0; % Set all background to 0
IC(index) = 0; 


neighbors = zeros(length(indices),7); 
neighbors(:,1) = indices;% Initialize matrix of neighbors : 
                         % Firtst Column includes the index of
                         % the element in the Geometry matrix 
                         % The next two columns contain the row
                         % and the column of the grid cell in 
                         % the Geometry Matrix
                    	 % and the next 4 columns include Ones
                         % in the respective entries of the 4 
                         % neighbors starting from north and
                         % go to west, east and south (see get_neigh_4).


for i=1:length(indices) % for all active grid cells, make a vector of neighbors and save it in rows of matrix(neigh_array)
      neigh_array(i,:) = neighbors_vect(i, G, indices);
end

neighbors(:,2:end) = neigh_array; % concatenate this matrix to get a matrix with entry's index, row, column and 4 neighbors.

temp = size(neighbors);
nu_neigh = temp(2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


options = odeset('AbsTol', 10^-6, 'RelTol', 10^-6, 'MaxStep', 0.5);
%% Stimulus

for k = 1:length(syn) % Specify the glutamate input of each synapse
    dur_act = 1*dur; % Stimulus parameters
    interv = 1000;
    activ_ratio = 1;
    fr = 10;
    
    glu = real_glu(dur, fr, dur_act, interv, activ_ratio); % Produce Stimulus
%     glu = [];
%     for j = 1:dur_act/interv
%         temp = 0.001*(ones(1,interv));
%         for i =1:interv*activ_ratio
%             temp(i) = glut(80);
%         end
%     %     temp = rand*temp;
%         glu = [glu,temp];
%     end
%     glu(end+1:dur) = 0.001;
%     glu = glu';
%     if k>(length(syn)/7 + 1)
%         tape = glu(dur/2+1:end);
%         glu = [tape; glu];
%         glu = glu(1:dur);
%     end
    cut = fix(k/7.05);
    if cut > 0
        glu(1:round((cut/11)*dur)) = 0.001;
    end
    glu_mat(k,:) = glu;
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
 d_coeff_I = 10; % Diffusion Constants
 d_coeff_Ca = 10; %0.16 
for p = 2:dur % for loop for the number of timesteps
   p
   time = [p-1:dt:p];
   C = zeros(length(neighbors),3); % Initialize Matrices
   C(:,1:2) = neighbors(:,2:3);
   H = zeros(length(neighbors),3);
   H(:,1:2) = neighbors(:,2:3);
   I = zeros(length(neighbors),3);
   I(:,1:2) = neighbors(:,2:3);
   parfor ii = 1:length(indices) % Parallel for loop for solving the ODEs for each grid cell
       [a1, a2, a3] = solv_diff_glu(ii, G, neighbors, time, CaC, h, IC, options, glu);%_mat, syn);%, DC_i_mat);
       C(ii,3) = a1; % each grid cell's value is saved in a column vector along its row and column due to parallel demands 
       H(ii,3) = a2;
       I(ii,3) = a3;
   end
   
   for jj = 1:length(indices) % Rearrange the updated values to match the geometry-matrices' structure
        r = C(jj,1); % Get the real matrices from the column vectors
        c = C(jj,2);
        CaC(r,c) = C(jj,3);
        IC(r,c) = I(jj,3);
        h(r,c) = H(jj,3);
   end
   
   Ca_dif = zeros(length(neighbors),3); % Initialize matrices for diffusion
   Ca_dif(:,1:2) = neighbors(:,2:3); % each grid cell's value is saved in a column vector along its row and column due to parallel demands 
   I_dif = zeros(length(neighbors),3);
   I_dif(:,1:2) = neighbors(:,2:3);
   parfor ii = 1:length(indices) % Diffusion Parallel for loop 
       %         ii
       [b1, b2] = diffusion_fun(ii, CaC, IC, neighbors, d_coeff_Ca, d_coeff_I);
       Ca_dif(ii, 3) = b1;
       I_dif(ii, 3) = b2;
       
   end
   for jj = 1:length(indices) % Rearrange the updated values to match the geometry-matrices' structure
        r = C(jj,1);
        c = C(jj,2);
        CaC(r,c) = Ca_dif(jj,3);
        IC(r,c) = I_dif(jj,3);
   end
   if p == 2 % Save the Ca and IP3 matrices to a txt file at the first time step
        dlmwrite('CaC_t.txt', CaC)
        dlmwrite('IC_t.txt', IC)
   elseif mod(p, 10) == 0 % Save the Ca and IP3 matrices every 10 time steps
       dlmwrite('CaC_t.txt', CaC, '-append')
       dlmwrite('IC_t.txt', IC, '-append')
   end
%    CaC_t(:,:,p) = CaC;
%    IC_t(:,:,p)= IC;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Data Retrieval

% Retrieve the txt file data for the part of the cell until the primary branch
% CaC_t = dlmread('CaC_t_TUM_serial.txt');
% IC_t = dlmread('IC_t_TUM_serial.txt');
% CaC_time = zeros(224,223, size(CaC_t,1)/224);
% IC_time = zeros(224,223, size(IC_t,1)/224);
% for r = 1:1:size(CaC_t,1)/224
%     r
%     CaC_time(:,:,r) = CaC_t((r-1)*224+1:r*224, 1:223);
%     IC_time(:,:,r) = IC_t((r-1)*224+1:r*224, 1:223);
% end
% t_rec = [0:10:dur];
% CaC_t = CaC_time;
% IC_t = IC_time;

%%%%%%%%%%%%%%%%%

% Retrieve the txt file data for the part of the cell until the secondary branch
CaC_t = dlmread('CaC_t.txt');
IC_t = dlmread('IC_t.txt');
CaC_time = zeros(66,65, size(CaC_t,1)/66);
IC_time = zeros(66,65, size(IC_t,1)/66);
for r = 1:1:size(CaC_t,1)/66
    r
    CaC_time(:,:,r) = CaC_t((r-1)*66+1:r*66, 1:65);
    IC_time(:,:,r) = IC_t((r-1)*66+1:r*66, 1:65);
end
t_rec = [0:10:dur];
CaC_t = CaC_time;
IC_t = IC_time;

