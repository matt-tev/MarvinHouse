function m = get_mass_edl(edl_system)
% get_mass_edl
%
% Returns the total current mass of the edl system.initial 
%
%
% Created: 10 Mar 2014 -rmalak
% Modified: 11 Apr 2014 -dallaire


m = (~edl_system.parachute.ejected)*edl_system.parachute.mass + ...
    (~edl_system.heat_shield.ejected)*edl_system.heat_shield.mass + ...    
    get_mass_rockets(edl_system) +...
    edl_system.sky_crane.mass + ...
    get_mass_rover(edl_system.rover);
    
    