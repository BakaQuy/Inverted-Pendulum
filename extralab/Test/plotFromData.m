%Ts=0.01;
%time=0:Ts:(length(Data(:,1))-1)*Ts;

% figure %Open a new window for plot.
% plot(time,Data(:,1),time,DataCommands(:)); %Plot the experiment (input and output).
% title('position');
% 
% figure %Open a new window for plot.
% plot(time,Data(:,2),time,DataCommands(:)); %Plot the experiment (input and output).
% title('velocity');
% 
% figure %Open a new window for plot.
% plot(time,Data(:,3)-Data(1,3),time,DataCommands(:)); %Plot the experiment (input and output).
% title('angle');
% 
% figure %Open a new window for plot.
% plot(time,Data(:,4),time,DataCommands(:)); %Plot the experiment (input and output).
% title('angle velocity');


%%% PLOT ALL IN THE SAME FIGURE
figure
grid on;
% plot(time,DataCommands(:),'m');
% hold on
plot(time,Data(:,1),'b');
hold on
plot(time,Data(:,2),'c');
hold on
plot(time,Data(:,3),'r');
hold on
plot(time,Data(:,4),'g');
title('Real')
legend('command','position','velocity','angle','angle velocity')

figure
grid on;
% plot(time,DataCommands(:),'m');
% hold on
plot(time,Data_kalman(:,1),'b');
hold on
plot(time,Data_kalman(:,2),'c');
hold on
plot(time,Data_kalman(:,3),'r');
hold on
plot(time,Data_kalman(:,4),'g');
title('Kalman')
legend('command','position','velocity','angle','angle velocity')
