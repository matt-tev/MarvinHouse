%graphs_motor
figure;
title('graphs_motor');

tauS = motor.torque_stall;
tauNL = motor.torque_noload;
wNL = motor.speed_noload;

tau = tau_dcmotor(omega,motor);
P = tau.*omega;

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
xlabel('motor shaft speed [rad/s]');
ylabel('motor power [W]');