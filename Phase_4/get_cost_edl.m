function total_cost = get_cost_edl(edl_system)
% get_cost_edl
%
% Computes the cost of the edl system in $US. Takes a valid edl_system
% struct as input.


cost_rover = get_cost_rover(edl_system.rover);

% A simlistic model based on mass of solid rocket fuel. Not terrible to a
% first order I suppose.
cost_fuel = edl_system.rocket.fuel_mass*edl_system.rocket.cost_per_kg;

% A simplistic model based on cost proportional to the area defined by the
% parachute diameter. The real area of material used is much greater than
% this area, so it isn't really a material-proportional model. 
cost_parachute = edl_system.parachute.cost_per_A*pi*(edl_system.parachute.diameter/2)^2;

% add up everything and get out of here
total_cost = cost_rover + cost_fuel + cost_parachute;
