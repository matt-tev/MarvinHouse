function m = get_mass_rockets(edl_system)
% get_mass_rockets
%
% Returns the curret total mass of all rockets on the edl system. 
%
% Created: 10 Mar 2014 -rmalak



if nargin<1 
    error('usage: get_mass_rockets(edl_system)');
else
    % compute initial total mass of rockets
    m = edl_system.num_rockets*(edl_system.rocket.structure_mass + edl_system.rocket.fuel_mass);
end


