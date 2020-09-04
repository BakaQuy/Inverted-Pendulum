% This code compute the A and B matrix from the value found in the transfer
% functions writen below. It also compute the K matrix for the regulator.


% A and B matrix + Transfer functions with parameters
% A = [0  1  0  0; 
%      0 -a  0  0;
%      0  0  0  1;
%      0  b -c -d]

% B = [0;
%      e;
%      0;
%      f]

% V      e
% - = -------
% I    s + a

% O         f (s - g)
% - = -------------------------
% I    (s + a) (s^2 + d*s + c)

% with g = -(b*e+f*a)/f  => b = -(g*f+f*a)/e 


%%% NUMERICAL VALUE FOR TRANSFER FUNCTION OBTAINED WITH THE S EXCITATION and with IdentificationCode.m
% V      e          51.286
% - = -------   =  ---------
% I    s + a       (s+10.41)

% O          f (s - g)                    21.023 (s-0.1069)
% - = ------------------------- = ---------------------------------
% I    (s + a) (s^2 + d*s + c)    (s+10.94) (s^2 + 0.6249s + 36.74)



%%% PARAMETER IDENTIFICATION
%Velocity transfer function
e = 51.286;
a = 10.41;

% Angle transfer function
f = 21.023;
g = 0.1069;
d = 0.6249;
c = 36.74;

b = -(g*f+f*a)/e;



%%% COMPUTE A, B and K MATRIX
s = -1; %switch to -1 for the pendulum up and to 1 for pendulum down

A = [0   1     0     0; 
     0  -a     0     0;
     0   0     0     1;
     0   s*b  s*(-c)  -d];
 
B =  [0; 
      e; 
      0; 
    s*(f)];
 
C = [1 0 0 0;
     0 0 1 0];
 
D = [0; 
     0];

SYS = ss(A,B,C,D);



%%% LQR
Q = [1 0  0  0;   % position not very important
     0 1  0  0;   % velocity of the cart not very important
     0 0  1000 0;   % position of the pendulum important
     0 0  0 50]; % the velocity of the pendulum in the up position must be equal to 0!
 
R = 1;

K = lqr(A,B,Q,R)  %(value used during the lab when the regulation worked) 

% eigs = [-10; -5; -50; -30]
% L_ = place(A',C',eigs_);
% L = L_'

% %%% KALMAN FILTER  (not finished yet)
% QN = 0.05;
% RN = 0.1*eye(2);
% NN = zeros(1,2);
% [KEST,L,P] = kalman(SYS,QN,RN);
% 
% %%% OBSERVER SYSTEM
% A_kal = A - L*C;
% B_kal = [B L];
% sys_kal = ss(A_kal, B_kal, eye(4), 0*B_kal);
% %u_kalman = [u;y];
