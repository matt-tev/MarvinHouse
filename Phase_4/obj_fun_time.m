function[total_time]=obj_fun_time(x,edl_system,planet,mission_events,tmax,experiment,end_event)
% OBJ_FUN_TIME
% 
% This function runs both simulations -- edl and rover -- to get a total
% time to land and travel the specified terrain. 
%
%


% Note: Although edl_system is modified in this function, the modifications
% are lost after the function terminates because the struct is not a
% returned argument and is not a global variable. Thus, we only ever are
% modifying a local copy.
%

% edl_system=define_chassis(edl_system,'steel');
% edl_system=define_motor(edl_system,'speed');
% edl_system=define_batt_pack(edl_system,'LiFePO4',10);

% ****************
% RUNNING THE EDL SIMULATION
% **
%
% Unpack the edl-related design variables and update the struct
edl_system.parachute.diameter = x(1);
edl_system.rocket.fuel_mass = x(5);
edl_system.rover.wheel_assembly.wheel.radius = x(2);
edl_system.rover.chassis.mass = x(3);
edl_system.rover.wheel_assembly.speed_reducer.diam_gear = x(4);
%
[time_edl_run,~,edl_system] = simulate_edl(edl_system,planet,mission_events,tmax);
time_edl = time_edl_run(end);
%
% *****************


% *****************
% RUNNING THE ROVER SIMULATION
% **
%
% Unpack the rover-related design variables and update the rover struct
%
% edl_system.rover.wheel_assembly.wheel.radius = x(2);
% edl_system.rover.chassis.mass = x(3);
% edl_system.rover.wheel_assembly.speed_reducer.diam_gear = x(4);


edl_system.rover = simulate_rover(edl_system.rover,planet,experiment,end_event);
time_rover = edl_system.rover.telemetry.completion_time;
%
% ****************


% ******************
% CALCULATE TOTAL TIME
% **
total_time = time_edl+time_rover;

