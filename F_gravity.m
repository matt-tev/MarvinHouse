function Fgt = F_gravity(terrain_angle, rover, planet)
    %   Function F_gravity takes input1 terrain_angle(vector), input2
    %   rover(struct), and input3 planet(struct) and outputs Fgt which is
    %   the force due to gravity acting on the rover

    if nargin ~= 3
        error('There must be two input arguments.');
    elseif any(terrain_angle) > 75 || any(terrain_angle) < -75
        error('All values of terrain_angle must be between -75 and +75 degrees.')
    elseif ~isstruct(rover)
        error('Rover must be a struct.')
    elseif ~isstruct(planet)
        error('Planet must be a struct.')
    else
        %MAYBE NOT RIGHT
        Fgt = get_mass(rover)*-sind(terrain_angle)*planet.g;
        %positive/ uphilll should yield negative force
        % should be vectorized
    end

end
