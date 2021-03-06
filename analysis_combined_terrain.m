% analysis_combined_terrain takes the rolling resistance coefficients and 
% slope angles to find the maximum velocity

NG = get_gear_ratio(speed_reducer);
radius = wheel.radius;
Crr_list = linspace(0.01,0.4,25);
slope_list_deg = linspace(-10,35,25);
x0 = motor.speed_noload;
[CRR,SLOPE] = meshgrid(Crr_list, slope_list_deg);
VMAX = zeros(size(CRR));

N = size(CRR,1);
for i=1:N
    for j=1:N
        Crr_sample = CRR(i,j);
        slope_sample = SLOPE(i,j);
        % v_max is the fastest the rover will go at any omega
        % slope_sample and Crr_sample gives specific origins to where the 
        % max velocity should be recorded 
        VMAX(i,j) = radius*fzero(@(omega)F_net(omega,slope_sample,rover,planet,Crr_sample),x0)/NG;
    end
end
   
surf(CRR, SLOPE, VMAX);
xlabel('CRR');
ylabel('SLOPE');
zlabel('VMAX');