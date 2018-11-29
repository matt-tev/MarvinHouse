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
edl_system=define_chassis(edl_system,'carbon');
edl_system.rover.chassis.mass = 251;
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


[t,Y,edl_system] = simulate_edl(edl_system,planet,mission_events,tmax,true);
edl_system.rover=simulate_rover(edl_system.rover,planet,experiment,end_event);
edl_system.rover.telemetry.completion_time

get_cost_rover(edl_system.rover)