function m = get_mass_rover(edl_system)
% get_mass_rover.m
%
% Computes the mass of the rover defined in rover field of the edl system 
% struct. Assumes that the rover is defined as a struct corresponding to 
% the specification of project Phase 1.
%
% MEEN 357 -- SPRING 2014
%
% Created: 10 Mar 2014 based on get_mass() from pahse 1. -rmalak



m = 6*(edl_system.rover.wheel_assembly.motor.mass + ...
    edl_system.rover.wheel_assembly.speed_reducer.mass + ...
    edl_system.rover.wheel_assembly.wheel.mass) + ...
    edl_system.rover.chassis.mass + ...
    edl_system.rover.science_payload.mass + ...
    edl_system.rover.power_subsys.mass;
