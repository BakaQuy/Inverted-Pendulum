close all;

%--------------------------------------
%For s signalPendulum
%--------------------------------------
% The identification of the system has been made with only this experiment,
% the data from the file loaded below have been used to obtain the transfer
% function of the velocity and the angle.
load S_command; % s command
load DataS; % data obtained with the s command

dataSelect = 2; % select data (position, velocity, theta, theta dot); dataSelect = 2 : velocity,  dataSelect = 3 : angle
Ts = 0.01;
SystemOrder = [0 1]; % Number of zeros and of poles (0 and 1), respectively. velocity: [0 1] and angle: [1 3]


u = (s/3.4)'; % scaling with our range of command for our motor
offset_u = 0; % offset already removed in the s command
u_ = u-offset_u; % remove the offset of the datacommand
y = Data(:,dataSelect).';
offset_y = y(1); %Operating point (offset of the sensor)
y_ = y-offset_y; % remove the offset of the sensor (important for the angle sensor in the down position)
time = 0:Ts:(length(y)-1)*Ts; %Vector saving the time steps.
sysIdent=IdentifySystem(u_,y_,SystemOrder,Ts);
plot(time,y_,'.');
hold on;
lsim(sysIdent,u_,time);
zpk(sysIdent)