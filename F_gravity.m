% Function F_gravity computes the component of force due to gravity, in 
% Newtons, acting in the direction of rover translation. 
%    
% CALLING SYNTAX
%   Fgt = F_gravity(terrain_angle, rover, planet)
% INPUTS
%   terrain_angle   array       Array of terrain angles [deg]
%   rover           struct      Data structure containing rover parameters
%   planet          struct      Data structure containing planet gravity parameter
% OUTPUTS
%   Fgt array Array of forces [N]
function Fgt = F_gravity(terrain_angle, rover, planet)
    % Data Validation
    if nargin ~= 3
        error('There must be three input arguments.');
    elseif any(terrain_angle > 75) || any(terrain_angle < -75)
        error('All values of terrain_angle must be between -75 and +75 degrees.')
    elseif ~isstruct(rover)
        error('Rover must be a struct.')
    elseif ~isstruct(planet)
        error('Planet must be a struct.')
    end
    
    Fgt = get_mass(rover)*-sind(terrain_angle)*planet.g;
    %positive/ uphilll should yield negative force
    % should be vectorized
    

end
