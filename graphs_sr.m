% Calculate the values needed to tau)out and omega_out
Ng = get_gear_ratio(speed_reducer);
tau = tau_dcmotor(omega,motor);
tau_out = Ng*tau;
omega = motor.speed_noload*(1-(tau - motor.torque_noload)/(motor.torque_stall - motor.torque_noload));
omega_out = omega/Ng;
power = tau_out*omega_out;

subplot(3,1,1)
%speed_speed_reducer vs torque_speed_reducer
plot(tau_out,omega_out)
xlabel('Torque (Nm)')
ylabel('Speed (rad/s)')
title('Speed vs. Torque')

subplot(3,1,2)
%power_speed_reducer vs torque_speed_reducer
plot(tau_out,power)
xlabel('Torque (Nm)')
ylabel('Power (W)')
title('Power vs. Torque')

subplot(3,1,3)
%power_speed_reducer vs speed_speed_reducer
plot(omega_out, power)
xlabel('Speed (rad/s)')
ylabel('Power (W)')
title('Power vs. Speed')
