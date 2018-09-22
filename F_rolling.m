%F_rolling
function Frr = F_rolling(omega, terrain_angle, rover, planet, Crr)
    if nargin ~= 5
        error('There must be 5 inputs.');
    elseif ~isvector(omega) || ~isvector(terrain_angle)
        error('The first two input arguments must be scalars or vectors');
    elseif terrain_angle > 75 || terrain_angle < -75
        error('The variable terrain_angle must be between the values of -75 degrees and 75 degrees.');
    elseif ~isstruct(rover) || ~isstruct(planet)
        error('The thrid and fourth input arguments must be structs.');
    elseif ~isvector(Crr) || Crr < 0
        error('The fifth input must be a positive scalar.');
    else
        % MAY BE WRONG DIRECTION AND MULTIPLE OF 6 INCORRECT
        %computes the rolling resistance summed over all six wheels. Assume that 1/6th the rover normal force
        %acts on each wheel.
        %IDK HOW TO FIND ROVER VELOCITY
        Fn = get_mass(rover)*planet.g*cosd(terrain_angle);
        Frr_simple = Crr*Fn;
        Frr = erf(40*omega/get_gear_ratio(rover.speed_reducer))*Frr_simple;
    end
        
end