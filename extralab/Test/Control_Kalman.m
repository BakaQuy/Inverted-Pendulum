%*********************************************************************
% Initialization
%*********************************************************************
openinout;
Tcycle=0.01;
lengthExp=10;
N0=lengthExp/Tcycle;
Data=zeros(N0,4); % we have access to only 2 measures
Data_e=zeros(N0,4); % we have access to only 2 measures
DataCommands=zeros(N0,1);
cond=1;
i=1;

%*********************************************************************
% Parameters
%*********************************************************************
upper_limit = 1.7; % saturation
lower_limit = -1.6;

upper_dead_zone = 0.8; %dead zone
lower_dead_zone = -0.7;

[in1,in2,in3,in4,in5,in6,in7,in8]=anain;

reference = [in1; -0.0244140625; 5.15625; -0.0146484375];%4.313476562500000; % position

offset_sensor = reference;

% Matrices of system around up position:
% x_dot = A x + B u
% y = C x + D u
A = [    0    1.0000         0         0;
         0  -10.4100         0         0;
         0         0         0    1.0000;
         0    4.3111   36.7400   -0.6249];
 
B = [ 0;
    51.2860;
      0;
    -21.0230];

C = [1 0 0 0;
     0 0 1 0]; % We only have access to measures of x and theta

% D = [0;0] but it will not be used
 
% to see where do L and K come from, check findParameterFromTF.m
K = [-1   -1.8497  -66.8128  -14.5675]; % good (result from lqr command)
% K =  [-1.0000   -1.8668  -68.5769  -11.9112]; %angle 1000; vel angle 50

L = [3.0367  -0.0678;
    4.6131   -0.9845;
   -0.0678   11.5434;
   -0.0035   66.6272]; % output of kalman command

% Precompute matrices we will need to calculate the observer
M = Tcycle*(A - LC + (1/Tcycle)*eye(4));
N = Tcycle*[B L];

% Initial Conditions
X_init = [0;0;0;0]; % we suppose the initial unknowns at zero
X_prev = x_init; % previous state

%*********************************************************************
% Save in real time
%*********************************************************************
u = 0;
while cond==1
	tic
	[in1,in2,in3,in4,in5,in6,in7,in8]=anain;
	% PUT YOUR CONTROL LAW HERE
	Data(i,1)=in1; % position
	Data(i,2)=in3; % angle
    measures = [in1-offset_sensor(1);in3-offset_sensor(3)];
    
    X_hat = M*X_prev + N*[u;measures];
    X_prev = X_hat;
    Data_e(i,:) = (X_hat+offset_sensor)';
    
    error = reference-(X_hat+offset_sensor);
    u = -K*(error);
    
    % We add the dead zone and if the input is to high, we set the input to the limit value of the
    % saturation
    if u >= 0
        input = u + upper_dead_zone;
        if input >= upper_limit
            input = upper_limit;
            u = upper_limit-upper_dead_zone;
        end
    elseif u < 0
        input = u + lower_dead_zone;
        if input <= lower_limit
            input = lower_limit;
            u = lower_limit-lower_dead_zone;
        end
    end
    
    
    % change the position of the cart in the middle of the experiment
%     if i == floor((N0+1)/2)
%         reference(1) = reference(1)+2;     
%     end     

    anaout(input,0);
    DataCommands(i) = u;
    
	i=i+1;
	t=toc;
	if t>Tcycle
		disp('Sampling time to small');
	else
		while toc<=Tcycle
		end
	end
	if i==N0+1
		cond=0;
	end
end
%*********************************************************************
% Plot
%*********************************************************************
closeinout;
i=i-1;
time=0:Tcycle:(i-1)*Tcycle;


%figure
%plot(time, Data(:,1), time, DataCommands(:),time,Data(:,2));