clear all
clc

dur = 300;

%global glu 

% glu = zeros(dur,1);
% for j = 1:dur
%     if j>dur/10 && j<9*dur/10
%         glu(j) = 5;
%     else
%         glu(j) = 0.002;
%     end    
% end 

glu = zeros(dur,1);
for j = 1:dur
    if j>60 && j<120
        glu(j) = 5;
    elseif j>180 && j<240
        glu(j) = 5;
    else
        glu(j) = 0.002;
    end    
end 
% dur_act = 1*dur;
% interv = 5000;
% activ_ratio = 0.75;
% 
% glu = [];
% for j = 1:dur_act/interv
%     temp = 0.001*(ones(1,interv));
%     for i =1:interv*activ_ratio
%         temp(i) = glut(80);
%     end
% %     temp = rand*temp;
%     glu = [glu,temp];
% end
% glu(end+1:dur) = 0.001;
% glu = glu';


dt = 0.5;
time = [1:dt:dur]';

%%
x0(1)=0.02866; x0(2)=0.8794;
x0(3)=0.07241;

options = odeset('AbsTol', 10^-6, 'RelTol', 10^-6, 'MaxStep', 0.1);
[t,x_sim] = ode45(@(t,x0)ODE_DP_FM(t, x0, glu),time,x0,options);

figure();
subplot(2,1,1)
plot(t, x_sim(:,1))
xlabel('time(s)')
ylabel('[Ca]')

subplot(2,1,2)
plot(t, x_sim(:,3))
xlabel('time(s)')
ylabel('[IP3]')