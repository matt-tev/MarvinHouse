% analysis_combined_terrain

Crr_list = linspace(0.01,0.4,25);
slope_list_deg = linspace(-10,35,25);
[CRR,SLOPE] = meshgrid(Crr_list, slope_list_deg);
VMAX = zeros(size(CRR));
omega = motor.speed_noload*(1 - ((tau_dcmotor(omega,motor)) - (motor.torque_noload))/((motor.torque_stall) - (motor.torque_noload)));

N = size(CRR,1);
for i=1:N
    for j=1:N
        Crr_sample = CRR(i,j);
        slope_sample = SLOPES(i,j);
        VMAX(i,j) = wheel.radius*(omega/get_gear_ratio(rover.speed_reducer)); 
            
    end
end
    
surf(CRR, SLOPE, VMAX);