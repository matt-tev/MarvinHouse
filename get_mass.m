%get_mass
function m = get_mass(rover)
disp(nargin)
    if nargin ~= 1
        error('There may only be one input.');
    elseif ~isstruct(rover)     
        error('The input rover must be a struct.');
    else
        mass = chassis.mass + power_subsys.mass + science_payload.mass ...
            + 6*(motor.mass + speed_reducer.mass + wheel.mass);
    end
        
    m = mass;
    
end