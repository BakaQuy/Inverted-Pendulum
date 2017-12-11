%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Control System Design Lab: Sample Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

openinout; %Open the ports of the analog computer.
Ts=0.01;%Set the sampling time.
lengthExp=30; %Set the length of the experiment (in seconds).
N0=lengthExp/Ts; %Compute the number of points to save the datas.
Data=zeros(N0,4); %Vector saving the datas. If there are several datas to save, change "1" to the number of outputs.
DataCommands=ones(N0,1); %Vector storing the input sent to the plant.
cond=1; %Set the condition variable to 1.
i=1; %Set the counter to 1.
tic %Begins the first strike of the clock.
time=0:Ts:(N0-1)*Ts; %Vector saving the time steps.

uppersaturation = 1.7; % saturation
lowersaturation = -1.6;

rightdeadzone = 0.8; %dead zone
leftdeadzone = -0.7;

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



reference = [0; -0.019531250000000; 5.083007812500000; -0.014648437500000];  %-0.024414062500000 %5.15
  
K1 = [-1   -1.8497  66.8128  14.5675];

input=0; %Input of the system.
while cond==1
    anaout(input,0); %Command to send the input to the analog computer.
    [in1,in2,in3,in4,in5,in6,in7,in8]=anain; %Acquisition of the measurements.
    Data(i,1)=in1; %Save one of the measurements (in1).
    Data(i,2)=in2;
    Data(i,3)=in3;
    Data(i,4)=in4;
    if i == 1
        reference(1) = Data(1,1);
    end
    input = -K*([Data(i,1);Data(i,2);Data(i,3);Data(i,4)]-reference);
    if input>0
        input=input+rightdeadzone;      %find experimentally!
        if input > uppersaturation
            input = uppersaturation;
        end
        DataCommands(i) = input;
    elseif input<0
        input=input+leftdeadzone;      %find experimentally!
        if input < lowersaturation
            input = lowersaturation;
        end
        DataCommands(i) = input;
    else
        DataCommands(i)=input;
    end
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
    

    if Data(i,3) > 4.7 && Data(i,3) < 5.5
        K = [-1   -1.8497  -66.8128  -14.5675];
    elseif Data(i,3) > 3.5 && Data(i,3) < 6.5
        K = 1/70*K1;
    else
        K = 1/50*K1;
    end
    
    i=i+1;
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

closeinout %Close the ports.





