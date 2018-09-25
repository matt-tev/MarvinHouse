function Frr = F_rolling(omega, terrain_angle, rover, planet, Crr)
    %   Function F_rolling takes input1 omega(vector),input2 terrain_angle
    %   (vector), input3 rover(struct), input4 planet(struct), and input5
    %   Crr(vector) and outputs Frr which is the rolling force exerted onto
    %   the wheels


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
        % MAY BE WRONG DIRECTION AND OFF BY MULTIPLE OF 6
        
        Fn = get_mass(rover)*planet.g*cosd(terrain_angle);
        Frr_simple = Crr*Fn;
        v = rover.wheel_assembly.wheel.radius*(omega/get_gear_ratio(rover.wheel_assembly.speed_reducer));
        Frr = erf(40*v)*Frr_simple;
    end
        
end