%*********************************************************************
% Initialization
%*********************************************************************
openinout;
Tcycle=0.01;
lengthExp=100;
N0=lengthExp/Tcycle;
Data=zeros(N0,2); % we have access to only 2 measures
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

reference = [4.313476562500000; % position
             -0.024414062500000;  % velocity
             5.156250000000000;  % angle (the sensor give this value when the pendulum is in the up position)
             -0.014648437500000]; % angular velocity

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
L = [3.0367   -0.0678;
    4.6131   -0.9845;
   -0.0678   11.5434;
   -0.0035   66.6272]; % output of kalman command

% Initial Conditions
x_init = [in1;0;in3;0]; % we suppose the initial unknowns at zero
x_prev = x_init; % previous state
%*********************************************************************
% Save in real time
%*********************************************************************
while cond==1
	tic
	[in1,in2,in3,in4,in5,in6,in7,in8]=anain;
	% PUT YOUR CONTROL LAW HERE
	Data(i,1)=in1; % position
	Data(i,2)=in3; % angle
    measures = [in1;in3];
    
    error_estimation = measures - C*x_prev; % error of the estimation
    states = Tcycle*(A-B*K+eye(4))*x_prev + Tcycle*B*K*reference + Tcycle*L*error_estimation; % x_hat
    x_prev = states;
    
    error = reference-states;
    u = K*(error);
    
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
    if i == floor((N0+1)/2)
        reference = [7.313476562500000; % new position
                    -0.024414062500000;  % velocity
                    5.156250000000000;  % angle
                    -0.014648437500000]; % angular velocity      
    end    

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