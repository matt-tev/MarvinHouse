function[Fgt]=F_gravity(terrain_angle, rover, planet)
% F_gravity.m
% Inputs:  terrain_angle:  array   Array of terrain angles [deg]
%                  rover:  struct  Data structure specifying rover 
%                                  parameters
%
% Outputs:           Fgt:  array   Array of forces [N]

% Check that 3 inputs have been given.
if nargin ~= 3
    error('Incorrect number of inputs.  There should be three inputs.');
end

% Check that the first input is a scalar or a vector
if isnumeric(terrain_angle) ~= 1
    error('First input must be a scalar or a vector');
end

% Check that all elements of the first argument are between -75 degrees
% and +75 degrees
if max(abs(terrain_angle)) > 75
    error('All elements of the first argument must be between -75 degrees and +75 degrees');
end

% Check that the second input is a struct
if isstruct(rover) ~= 1 || isstruct(planet) ~= 1
    error('Last two inputs must be type struct');
end

% Main code
m_rover = get_mass_rover(rover);
g_mars  = planet.g;

Fgt = -m_rover*g_mars*sind(terrain_angle);

