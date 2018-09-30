% analysis_rolling_resistance

NG = get_gear_ratio(speed_reducer);
radius = wheel.radius;
Crr_list = linspace(0.01,0.4,25);
x0 = motor.speed_noload;
v_max = zeros(1,length(Crr_list));

for i = 1:length(Crr_list)
    v_max(i) = radius*fzero(@(omega)F_net(omega,terrain_angle,rover,planet,Crr_list(i)),x0)/NG;
end
plot(v_max,Crr_list);
xlabel('Velocity Max (m/s)');
ylabel('Crr List');