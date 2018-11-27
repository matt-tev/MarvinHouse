function F = F_drag_descent(edl_system,planet,altitude,velocity)
% F_drag_descent
% 
% Compute the net drag force. 


% compute the density of planetary atmosphere at current altitude
density = get_local_atm_properties(planet, altitude);

% This is the (1/2)*density*velocity^2 part of the drag model. The missing
% bit is area*Cd, which we'll figure out below.
rhov2=0.5*density*velocity^2;


% *************************************
% Determine which part(s) of the EDL system are contributing to drag

% If the heat shield has not been ejected, use that as our drag
% contributor. Otherwise, use the sky crane.
if ~edl_system.heat_shield.ejected
    ACd_body = pi*(edl_system.heat_shield.diameter/2.0)^2*edl_system.heat_shield.Cd;
else
    ACd_body = edl_system.sky_crane.area*edl_system.sky_crane.Cd;
end

% if the parachute is in the deployed state, need to account for its area
% in the drag calculation
if edl_system.parachute.deployed && ~edl_system.parachute.ejected
    ACd_parachute = pi*(edl_system.parachute.diameter/2.0)^2*edl_system.parachute.Cd;
else
    ACd_parachute = 0.0;
end


% This computes the ultimate drag force
F=rhov2*(ACd_body+ACd_parachute);
   
   


