function m = get_mass(rover)
    %   Function get_mass takes input input rover(struct) and outputs m
    %   which is the mass of the entire rover

    if nargin ~= 1
        error('There may only be one input.');
    elseif ~isstruct(rover)     
        error('The input rover must be a struct.');
    else
        %MAYBE NOT RIGHT
        mass = chassis.mass + power_subsys.mass + science_payload.mass ...
            + 6*(motor.mass + speed_reducer.mass + wheel.mass);
    end
        
    m = mass;
    
end