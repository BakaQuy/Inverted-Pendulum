%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Control System Design Lab: Sample Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

openinout; %Open the ports of the analog computer.
Ts=0.01;%Set the sampling time.
lengthExp=10; %Set the length of the experiment (in seconds).
%N0=lengthExp/Ts; %Compute the number of points to save the datas.
N0 = length(s);
Data=zeros(N0,4); %Vector saving the datas. If there are several datas to save, change "1" to the number of outputs.
DataCommands=zeros(N0,1); %Vector storing the input sent to the plant.
cond=1; %Set the condition variable to 1.
i=1; %Set the counter to 1.
tic %Begins the first strike of the clock.
time=0:Ts:(N0-1)*Ts; %Vector saving the time steps.

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
while cond==1    
    
    %input=0.8; %Input of the system.
%     if i < 10 %&& i < 50
%         input = 0.8;
%         %disp('input 1.7')
%     else 
%         input = 1.3;
%         %disp('input 0')
%     end
    %DataCommands(i,1)=input;
    
    % S command
    if s(i) < 0
        DataCommands(i,1)=s(i)/3.4;
        anaout(s(i)/3.4-0.7,0); %Command to send the input to the analog computer.
    elseif s(i) >= 0
        DataCommands(i,1)=s(i)/3.4;
        anaout(s(i)/3.4+0.8,0); %Command to send the input to the analog computer.
    end   
    
    [in1,in2,in3,in4,in5,in6,in7,in8]=anain; %Acquisition of the measurements.
    Data(i,1)=in1; % position
    Data(i,2)=in2; % velocity
    Data(i,3)=in3; % angle
    Data(i,4)=in4; % angle velocity
    t=toc; %Second strike of the clock.
    if t>i*Ts
        disp('Sampling time too small');%Test if the sampling time is too small.
    else
        while toc<=i*Ts %Does nothing until the second strike of the clock reaches the sampling time set.
        end
    end
    if i==N0 %Stop condition.
        cond=0;
    end
    i=i+1;
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

closeinout %Close the ports.

figure %Open a new window for plot.
plot(time,Data(:,1),time,DataCommands(:)); %Plot the experiment (input and output).
title('position');

figure %Open a new window for plot.
plot(time,Data(:,2),time,DataCommands(:)); %Plot the experiment (input and output).
title('velocity');

figure %Open a new window for plot.
plot(time,Data(:,3),time,DataCommands(:)); %Plot the experiment (input and output).
title('angle');

figure %Open a new window for plot.
plot(time,Data(:,4),time,DataCommands(:)); %Plot the experiment (input and output).
title('angle velocity');