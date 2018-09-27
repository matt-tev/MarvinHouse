%graphs_motor
figure;
title('graphs_motor');

tauS = motor.torque_stall;
tauNL = motor.torque_noload;
wNL = motor.speed_noload;

tau = tau_dcmotor(omega,motor);
P = tau.*omega;

%The following is done to graph the max power point
Pmax = max(P);
index = find(P == Pmax);
X_max = omega(index);
% The max power and the omega at which that power occurs have been found

subplot(3,1,1)

plot(tau,omega);
xlabel('motor shaft torque [Nm]');
ylabel('motor shaft speed [rad/s]');

subplot(3,1,2)
plot(tau,P);
xlabel('motor shaft torque [Nm]');
ylabel('motor power [W]');

subplot(3,1,3)
plot(omega,P);
hold on
plot(X_max,Pmax,'r*')
xlabel('motor shaft speed [rad/s]');
ylabel('motor power [W]');
grid on
hold off