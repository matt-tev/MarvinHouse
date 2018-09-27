% script called analysis_terrain_slope

Crr = 0.2;
slope_list_deg = linspace(-10,35,25);
x0 = motor.speed_noload;
v_max = fzero(@(omega)Vrover(rover,omega),x0);

plot(v_max,slope_list_deg);
xlabel('v_max (m/s)');
ylabel('slope_list_deg (deg)');