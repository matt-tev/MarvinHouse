% script called analysis_terrain_slope

NG = get_gear_ratio(speed_reducer);
radius = wheel.radius;
Crr = 0.2;
slope_list_deg = linspace(-10,35,25);
v_max = zeros(1,length(slope_list_deg));

x0 = motor.speed_noload;
for i=1:length(slope_list_deg)
    % v_max is the fastest the rover will go at any omega
    % slope_list_deg(i) gives specific origins to where the max velocity
    % should be recorded 
    v_max(i) = radius*fzero(@(omega)F_net(omega,slope_list_deg(i),rover,planet,Crr),x0)/NG;
end

plot(v_max,slope_list_deg);
xlabel('Velocity Max (m/s)');
ylabel('Slope (deg)');
