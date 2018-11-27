function F = F_buoyancy_descent(edl_system,planet,altitude)
% F_buoyancy_descent
% 
% Compute the net buoyancy force. 

density = get_local_atm_properties(planet, altitude);

F = sign(planet.g)*planet.g*density*edl_system.volume;

   


