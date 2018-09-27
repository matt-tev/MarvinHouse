% script called analysis_terrain_slope

NG = get_gear_ratio(speed_reducer);
radius = wheel.radius;
Crr = 0.2;
slope_list_deg = linspace(-10,35,25);
x0 = motor.speed_noload;
for i=1:length(slope_list_deg)
    v_max(i) = radius*fzero(@(omega)F_net(omega,slope_list_deg,rover,planet,Crr),x0)/NG;
end

plot(v_max(i),slope_list_deg);
xlabel('Velocity Max (m/s)');
ylabel('Slope (deg)');
