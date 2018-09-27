% analysis_rolling_resistance

Crr_list = linspace(0.01,0.4,25);
omega = motor.speed_noload*(1 - ((tau_dcmotor(omega,motor)) - (motor.torque_noload))/((motor.torque_stall) - (motor.torque_noload)));
Vrover = wheel.radius*(omega/get_gear_ratio(rover.speed_reducer));
fun = Vrover;
x0 = motor.speed_noload;
v_max = fzero(fun,x0);

plot(v_max,Crr_list);
xlabel('v_max');
ylabel('Crr_list');