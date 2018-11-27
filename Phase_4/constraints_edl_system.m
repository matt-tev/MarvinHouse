function[c,ceq]=constraints_edl_system(x,edl_system,planet,mission_events,tmax,experiment,end_event,...
    min_strength,max_rover_velocity,max_cost,max_batt_energy_per_meter)
% constraints_edl_system
%
% This function evaluates the nonlinear constraints for the optimization
% problem to maximize speed (minimize time)
%
% To evaluate the constraints entails simulating both the edl system and the
% rover. Thus, this function calls simulate_edl and simulate_rover.
%


% CONSTRAINTS_EDL_SYSTEM
% 

% edl_system=define_chassis(edl_system,'steel');
% edl_system=define_motor(edl_system,'speed');
% edl_system=define_batt_pack(edl_system,'LiFePO4',10);


% ****************
% RUNNING THE EDL SIMULATION
% **
%
% Unpack the edl-related design variables and update the struct
edl_system.parachute.diameter=x(1);
edl_system.rocket.fuel_mass=x(5);
edl_system.rover.wheel_assembly.wheel.radius = x(2);
edl_system.rover.chassis.mass = x(3);
edl_system.rover.wheel_assembly.speed_reducer.diam_gear = x(4);

%
% run the edl simulation
[~,~,edl_system] = simulate_edl(edl_system,planet,mission_events,tmax);
% time_edl = time_edl_run(end);
%
% *****************


% *****************
% RUNNING THE ROVER SIMULATION
% **
%
% Unpack the rover-related design variables and update the rover struct
% edl_system.rover.wheel_assembly.wheel.radius = x(2);
% edl_system.rover.chassis.mass = x(3);
% edl_system.rover.wheel_assembly.speed_reducer.diam_gear = x(4);
%
% run the rover simulation
edl_system.rover = simulate_rover(edl_system.rover,planet,experiment,end_event);
% time_rover = edl_system.rover.telemetry.completion_time;
%

% *****************
% EVALUATE THE CONSTRAINT FUNCTIONS
% **
% Note: some of the following simply normalizes the constraints to be on
% similar orders of magnitude.
%
%
% The rover must travel the complete distance
constraint_distance = (end_event.max_distance-edl_system.rover.telemetry.distance_traveled)/end_event.max_distance;
%
% The chassis must be strong enough to survive the landing
chassis_strength = edl_system.rover.chassis.mass*edl_system.rover.chassis.specific_strength;
constraint_strength = -(chassis_strength-min_strength)/min_strength;
%
% The battery must not run out of charge
constraint_battery  = (edl_system.rover.telemetry.batt_energy_per_distance-max_batt_energy_per_meter)/max_batt_energy_per_meter;
%
% The touchdown speed of the rover must not be too much (or else damage may occur) 
constraint_velocity = (abs(edl_system.velocity(end))-abs(max_rover_velocity))/abs(max_rover_velocity);
%
% The total cost cannot exceed our budget
constraint_cost = (get_cost_edl(edl_system)-max_cost)/max_cost;


% *****************
% CONSTRUCT THE CONSTRAINT VECTORS THAT MATLAB REQUIRES
% **
c=[constraint_distance;constraint_strength;constraint_velocity;constraint_cost; constraint_battery];
ceq=[];
