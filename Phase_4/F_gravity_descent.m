function F = F_gravity_descent(edl_system,planet)
% F_gravity_descent
% 
% Compute the gravitational force acting on the EDL system

F = get_mass_edl(edl_system)*planet.g;

   


