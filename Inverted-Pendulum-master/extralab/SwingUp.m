%*********************************************************************
% Initialization
%*********************************************************************
openinout;
Tcycle=0.01;
lengthExp=20;
N0=lengthExp/Tcycle;
Data=zeros(N0,4);
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

K = [-1   -1.8497  -66.8128  -14.5675]; % good

eps = 0; %VARIABLE, can change: the desired engergy value
    g = 9.81;
    l = 0.15; %CHANGE
    m = 0.2; %CHANGE
    alfa = 1; %VARIABLE, can chage
    
    %parameters
    e = 51.286;
    a = 10.41;
    f = 21.023;
    g = 0.1069;
    d = 0.6249;
    c = 36.74;
    b = -(g*f+f*a)/e;
    
    t1 = -alfa/b*1/2*m*l^2;
    t2 = -alfa/b*m*g*l;
    t3 = a/b;
    
    
         
%*********************************************************************
% Save in real time
%*********************************************************************
while cond==1
	tic
	[in1,in2,in3,in4,in5,in6,in7,in8]=anain;

	% PUT YOUR CONTROL LAW HERE
	Data(i,1)=in1; % position
	Data(i,2)=in2; % velocity
	Data(i,3)=in3; % angle
	Data(i,4)=in4; % angular velocity
    
    states = [in1;
              in2;
              in3;
              in4];
          
    
             
        angle = in3/10*360; %in degree
         k = (t1*in4^2+t2*(cos(angle)-1-eps)*in4*cos(angle))+t3*in2;
         
         if in4>0 && ((in3>=9.8&& in3 <=9.9)|| (in3<=0.2&& in3 >=0.1)) 
            u=k;
         elseif in4<0 && ((in3>=9.8&& in3 <=9.9)|| (in3<=0.2&& in3 >=0.1)) 
            u =k; 
         end
           
    % We add the dead zone and if the input is to high, we set the input to the limite value of the
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
%         reference = [7.313476562500000; % new position
%                     -0.024414062500000;  % velocity
%                     5.156250000000000;  % angle
%                     -0.014648437500000]; % angular velocity      
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
anaout(0,0);
closeinout;
i=i-1;
time=0:Tcycle:(i-1)*Tcycle;


%figure
%plot(time, Data(:,1), time, DataCommands(:),time,Data(:,2));
