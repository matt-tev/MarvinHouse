%F_net
function F = F_net(omega,terrain_angle,rover,planet, Crr)
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
        %PROBABLY NOT RIGHT
        F = F_drive(oemga,rover)- ...
             F_Rolling(omega,terrain_angle,rover,planet,Crr) - ... 
                F_gravity(terrain_angle,rover,planet);
    end
end