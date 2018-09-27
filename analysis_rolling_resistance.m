% analysis_rolling_resistance

Crr_list = linspace(0.01,0.4,25);
Vrover = wheel.radius*(omega/get_gear_ratio(rover.wheel_assembly.speed_reducer));
fun = Vrover;
x0 = motor.speed_noload;
v_max = fzero(fun,x0);

plot(v_max,Crr_list);
xlabel('v_max');
ylabel('Crr_list');