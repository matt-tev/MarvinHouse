%
% opt_edl_system.m
%

clc
close all
clear all

% the following calls instantiate the needed structs and also make some of
% our design selections (battery type, etc.)
define_planet;
define_edl_system;
define_mission_events;
edl_system=define_chassis(edl_system,'steel');
edl_system=define_motor(edl_system,'base');
edl_system=define_batt_pack(edl_system,'LiFePO4',19);

% these are parameters of the simulation itself, including the maximum
% simulation time and the end event conditions 
tmax = 3000;
end_event.max_distance = 1000;   % [m]
end_event.max_time     = 10000;  % [s]
end_event.min_velocity = 1e-2;  % [m/s]

load experiment1;

max_rover_velocity = -1;
min_strength=40000;
max_cost = 7e6;
max_batt_energy_per_meter = edl_system.rover.power_subsys.battery.capacity/1000;



% ******************************
% DEFINING THE OPTIMIZATION PROBLEM
% ****
% Design vector elements (in order):
%   - parachute diameter [m]
%   - wheel radius [m]
%   - chassis mass [kg]
%   - speed reducer gear diameter (d2) [m]
%   - rocket fuel mass [kg]
%

% search bounds
x_lb = [14     ; 0.2       ; 250   ; 0.05  ; 100];
x_ub = [19     ; 0.7       ; 800   ; 0.12  ; 290];

% initial guess
x0 =   [17  ; .4   ; 600   ; 0.09  ; 250];


% handle to objective function
objective_function = @(x) obj_fun_time(x,edl_system,planet,mission_events,tmax,experiment,end_event);

% handle to nonlinear constraint function
constraint_function = @(x) constraints_edl_system(x,edl_system,planet,mission_events,tmax,experiment,end_event,...
    min_strength,max_rover_velocity,max_cost,max_batt_energy_per_meter);

% optimization options, including which algorithm to use and so forth
options=optimset('Algorithm','sqp','InitBarrierParam',0.1,'Display','iter-detailed', 'UseParallel', 'always','ScaleProblem','obj-and-constr');

% here is where we actually call the optimizer
[x_star,fval,exitFlag]=fmincon(objective_function,x0,[-1,-1,-1,-1,-1],....
    [0],[],[],x_lb,x_ub,constraint_function,options);

% check that we have a feasible solution
if exitFlag > 0
    xbest=x_star;
    fbest=fval;
else % give nonsensical numbers for optimal if we are infeasible (start over if you see these with a different initial guess)
    xbest = [99999, 99999, 99999, 99999, 99999];
    fval  = 99999;
end


% The following will rerun your best design and present useful information
% about the performance of the design
% This will be helpful if you choose to create a loop around lines 53-74
% to try different starting points for the optimization.


edl_system.parachute.diameter=xbest(1);
edl_system.rover.wheel_assembly.wheel.radius = xbest(2);
edl_system.rover.chassis.mass = xbest(3);
edl_system.rover.wheel_assembly.speed_reducer.diam_gear = xbest(4);
edl_system.rocket.fuel_mass=xbest(5);

% These lines save your design for submission for the race.
% You will want to change them to match your team information.

% edl_system.team_name = 'MARVIN';
% edl_system.team_number = 9999;
% save challenge_design_team9999.mat edl_system


[time_edl_run,Y,edl_system] = simulate_edl(edl_system,planet,mission_events,tmax);
time_edl_comp = time_edl_run(end)


edl_system.rover = simulate_rover(edl_system.rover,planet,experiment,end_event);
time_rover_comp = edl_system.rover.telemetry.completion_time

time_comp = time_edl_comp + time_rover_comp;


edl_system_total_cost=get_cost_edl(edl_system);

       fprintf('----------------------------------------\n');
       fprintf('----------------------------------------\n');
       fprintf('Optimized parachute diameter   = %6g [m]\n',  xbest(1));
       fprintf('Optimized rocket fuel mass     = %6g [kg]\n', xbest(5));
       fprintf('Time to complete EDL mission   = %6g [s]\n', time_edl_comp);
       fprintf('Rover velocity at landing      = %6g [m/s]\n', edl_system.velocity(end));
       fprintf('Optimized wheel radius         = %6g [m]\n', xbest(2)); 
       fprintf('Optimized d2                   = %6g [m]\n', xbest(4)); 
       fprintf('Optimized chassis mass         = %6g [kg]\n', xbest(3)); 
       fprintf('Time to complete rover mission = %6g [s]\n', time_rover_comp);
       fprintf('Time to complete mission       = %6g [s]\n', time_comp);
       fprintf('Average velocity               = %6g [m/s]\n', edl_system.rover.telemetry.average_velocity);
       fprintf('Distance traveled              = %6g [m]\n', edl_system.rover.telemetry.distance_traveled);
       fprintf('Battery energy per meter       = %6g [J/m]\n', edl_system.rover.telemetry.batt_energy_per_distance);
       fprintf('Total cost                     = %6g [$]\n', edl_system_total_cost);
       fprintf('----------------------------------------\n');
       fprintf('----------------------------------------\n');