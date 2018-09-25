Ng = get_gear_ratio(speed_reducer);
tau = tau_dcmotor(omega,motor);
tau_out = Ng*tau;
omega = motor.speed_noload*(1-(tau - motor.torque_noload)/(motor.torque_stall - motor.torque_noload))

subplot(3,1,1)
%speed_speed_reducer vs torque_speed_reducer
plot(speed_reducer.speed
xlabel('Torque (Nm)')
ylabel('Speed (rad/s)')

subplot(3,1,2)
%power_speed_reducer vs torque_speed_reducer
xlabel('Torque (Nm)')
ylabel('Power (W)')

subplot(3,1,3)
%power_speed_reducer vs speed_speed_reducer
xlabel('Speed (rad/s)')
ylabel('Power (W)')
