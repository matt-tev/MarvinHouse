% analysis_combined_terrain takes the rolling resistance coefficients and 
% slope angles to find the maximum velocity

Crr_list = linspace(0.01,0.4,25);
slope_list_deg = linspace(-10,35,25);
[CRR,SLOPE] = meshgrid(Crr_list, slope_list_deg);
VMAX = zeros(size(CRR));

N = size(CRR,1);
for i=1:N
    for j=1:N
        Crr_sample = CRR(i,j);
        slope_sample = SLOPE(i,j);
        VMAX(i,j) = wheel.radius*(omega/get_gear_ratio(rover.wheel_assembly.speed_reducer));     
    end
end
   
surf(CRR, SLOPE, VMAX);