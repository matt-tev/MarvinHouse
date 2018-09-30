function m = get_mass(rover)
    %   Function get_mass takes input input rover(struct) and outputs m
    %   which is the mass of the entire rover

    % error check
    if nargin ~= 1
        error('There may only be one input.');
    elseif ~isstruct(rover)     
        error('The input rover must be a struct.');
    else
        mass = rover.chassis.mass + rover.power_subsys.mass + rover.science_payload.mass + 6*(rover.wheel_assembly.motor.mass + rover.wheel_assembly.speed_reducer.mass + rover.wheel_assembly.wheel.mass);
    end
        
    m = mass;
    
end