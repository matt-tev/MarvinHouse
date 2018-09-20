%F_gravity
function Fgt = F_gravity(terrain_angle, rover, planet)
    if nargin ~= 3
        error('There must be two input arguments.');
    elseif ~isvector(omega)
        error('Omega must be a scalar or vector.');
    elseif terrain_angle > 75 || terrain_angle < -75
        error('terrain_angle must be between -75 and +75 degrees.')
    elseif ~isstruct(rover)
        error('Rover must be a struct.')
    elseif ~isstruct(planet)
        error('Planet must be a struct.')
    else
        Fgt = get_mass(rover)*-sind(terrain_angle)*planet.g;
        %positive/ uphilll should yield negative force
        % should be vectorized
    end

end
