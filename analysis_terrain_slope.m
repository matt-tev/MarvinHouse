% script called analysis_terrain_slope

Crr = 0.2;
slope_list_deg = linspace(-10,35,25);
fun = 
x0 = motor.speed_noload;
v_max = fzero(fun,x0);

plot(v_max,slope_list_deg)
xlabel('v_max')
ylabel('slope_list_deg')