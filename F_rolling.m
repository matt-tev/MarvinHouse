% Function F_rolling computes the component of force due to rolling 
% resistance, in Newtons, acting in the direction of rover translation.
%    
% CALLING SYNTAX
%   Frr = F_rolling(omega, terrain_angle, rover, planet, Crr)
% INPUTS
%   omega           N element array     Array of motor shaft speeds [rad/s]
%   terrain_angle   N element array     Array of terrain angles [deg]
%   rover           struct              Data structure containing rover parameters
%   planet          struct              Data structure containing planet gravity parameter
%   Crr             scalar              Value of rolling resistance coefficient [-]
% OUTPUTS
%   Frr             array               Array of forces [N]


function Frr = F_rolling(omega, terrain_angle, rover, planet, Crr)
    %   Function F_rolling takes input1 omega(vector),input2 terrain_angle
    %   (vector), input3 rover(struct), input4 planet(struct), and input5
    %   Crr(vector) and outputs Frr which is the rolling force exerted onto
    %   the wheels
    
    % Data Validation
    if nargin ~= 5
        error('There must be 5 inputs.');
    elseif (~isvector(omega) || ~isvector(terrain_angle)) || length(omega) ~= length(terrain_angle)
        error('The first two input arguments must be scalars or vectors of the same size.');
    elseif any(terrain_angle) > 75 || any(terrain_angle) < -75
        error('The variable terrain_angle must be between the values of -75 degrees and 75 degrees.');
    elseif ~isstruct(rover) || ~isstruct(planet)
        error('The thrid and fourth input arguments must be structs.');
    elseif ~isvector(Crr) || Crr < 0
        error('The fifth input must be a positive scalar.');
    end
    % these next lines tell the output function how many arguments to output
    % in order to be the same length as the omega input
    Fn = zeros(1,length(terrain_angle));
    Frr_simple = zeros(1,length(terrain_angle));
    v = zeros(1,length(omega));
    Frr = zeros(1,length(omega));
        
    for i = 1:length(omega)
        Fn(i) = -get_mass(rover)*planet.g*cosd(terrain_angle(i));
        Frr_simple(i) = Crr*Fn(i);
        v(i) = rover.wheel_assembly.wheel.radius*(omega(i)/get_gear_ratio(rover.wheel_assembly.speed_reducer));
        Frr(i) = (erf(40*v(i))*Frr_simple(i));
    end
    
        
end