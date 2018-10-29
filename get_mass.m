% Function get_mass computes rover mass in kilograms. It accounts for the 
% chassis, power subsystem, science payload, and six wheel assemblies, 
% which itself is comprised of a motor, speed reducer, and the wheel itself.
%    
% CALLING SYNTAX
%   m = get_mass(rover)
% INPUTS
%   rover   struct      Data structure containing rover parameters
% OUTPUTS
%   m       scalar      Rover mass [kg]
function m = get_mass(rover)
    % Data Validation
    if nargin ~= 1
        error('There may only be one input.');
    elseif ~isstruct(rover)     
        error('The input rover must be a struct.');
    end
    
    m = rover.chassis.mass + rover.power_subsys.mass + ...
            rover.science_payload.mass + ...
                6*(rover.wheel_assembly.motor.mass + ...
                    rover.wheel_assembly.speed_reducer.mass + ...
                        rover.wheel_assembly.wheel.mass);
end