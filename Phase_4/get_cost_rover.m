function total_cost = get_cost_rover(rover)
% get_cost_rover
%
% Computes the cost of the rover. Requires a valid rover struct as input.
%
%

% Wheel cost as a function of wheel radius.
% accounts for the fact that there are six wheels.
wheel_radius=rover.wheel_assembly.wheel.radius;
if wheel_radius > 0.5
    cost_wheels = 90000;
else
    cost_wheels = 0.5e7*(wheel_radius^3-0.1^3)+1e4;
end

cost_battery = rover.power_subsys.battery.cost;

% Speed reducer cost as a function of the gear diameter.
% Accounts for the fact that there are six speed reducers.
d2=rover.wheel_assembly.speed_reducer.diam_gear;
cost_d2      = 5e7*(d2^2-0.04^2);

% remember that there are six motors
cost_motor = 6*rover.wheel_assembly.motor.cost;

% Chassis cost as a function of strength and material quantity
cost_chassis=(rover.chassis.specific_strength/100)^2*1000*rover.chassis.mass+50000;



total_cost = cost_wheels+cost_battery+cost_d2+cost_motor+cost_chassis;

