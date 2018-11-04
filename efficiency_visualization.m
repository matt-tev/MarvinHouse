%efficiency_visualization
tau_data = motor.effcy_tau;
eff_data = motor.effcy*100;
tau_motor = linspace(motor.torque_noload,motor.torque_stall,100);

% calculate the efficiency based on torque values given in the rover struct
eff = interp1(tau_data,eff_data,tau_motor,'spline');

% plot efficiency vs. torque
plot(tau_motor,eff,'k','LineWidth',1)
xlabel('Torque (N-m)')
ylabel('Efficiency (%)')
title('Efficiency vs. Torque')
hold on 
plot(tau_data,eff_data,'r*')
hold off