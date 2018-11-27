function rover=simulate_rover(rover,planet,experiment,end_event)


% end_event.max_distance = 400;
% end_event.max_time     = 1000;
% end_event.min_velocity = 1e-2;


% REQUIRED LINE OF CODE FOR EVENT HANDLER
% This ensures the simulation halts when the final distance is reached
% note: end_of_mission_event.m must be in your pwd or MATLAB path
options = odeset('Events',@(t,y)end_of_mission_event(t,y,end_event));

rover.position=experiment.initial_conditions(2);
rover.velocity=experiment.initial_conditions(1);

[T,Y] = ode15s(@(t,y)rover_dynamics(t,y, rover, planet, experiment),...
    experiment.time_range,experiment.initial_conditions,options);

rover.telemetry.time               = T;
rover.telemetry.completion_time    = T(end);
rover.telemetry.velocity           = Y(:,1);
rover.telemetry.position           = Y(:,2);
rover.telemetry.distance_traveled  = rover.telemetry.position(end);
rover.telemetry.max_velocity       = max(rover.telemetry.velocity);
rover.telemetry.average_velocity   = mean(rover.telemetry.velocity);
rover.telemetry.power              = mechpower(rover.telemetry.velocity,rover);
rover.telemetry.energy             = 6*trapz(rover.telemetry.time,rover.telemetry.power);

Ng     = get_gear_ratio(rover.wheel_assembly.speed_reducer);
r     = rover.wheel_assembly.wheel.radius;
total_ratio = Ng/r;

omega_motor = rover.telemetry.velocity * total_ratio;
rover.telemetry.tau_motor    = tau_dcmotor(omega_motor,rover.wheel_assembly.motor);

% x=rover.wheel_assembly.motor.tau_effcy(:,1)*rover.wheel_assembly.motor.torque_stall;
% y=rover.wheel_assembly.motor.tau_effcy(:,2);
% xi=rover.telemetry.tau_motor;
% rover.telemetry.efficiency   = interp1(x,y,xi,'spline');
v=rover.telemetry.velocity;
t=rover.telemetry.time;


rover.telemetry.battery_energy = battenergy(v,t,rover);
%rover.telemetry.energy_per_distance=rover.telemetry.energy/rover.telemetry.distance_traveled;
rover.telemetry.batt_energy_per_distance = rover.telemetry.battery_energy/rover.telemetry.distance_traveled;

rover.position=Y(end,2);
rover.velocity=Y(end,1);


