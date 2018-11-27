function[F]=F_net(omega_motor, terrain_angle, rover, planet)
% F_net.m
% Inputs:    omega_motor:  array   Array of motor shaft speeds [rad/s]
%          terrain_angle:  array   Array of terrain angles [deg]
%                  rover:  struct  Data structure specifying rover 
%                                  parameters
%
% Outputs:             F:  array   Array of forces [N]

% Check that 4 inputs have been given.
if nargin ~= 4
    error('F_net: Incorrect number of inputs.  There should be four inputs.');
end

% Check that the first two inputs are scalars or vectors 
if any(~isnumeric(omega_motor)) || any(~isvector(omega_motor))
    error('F_net: first input argument must be a vector of numeric values for motor speed [rad/s]');
end
if any(~isnumeric(terrain_angle)) || any(~isvector(terrain_angle))
    error('F_net: second input argument must be a vector of numeric values for terrain angle [deg]');
end

% Check that all elements of the second argument are between -75 degrees
% and +75 degrees
if max(abs(terrain_angle)) > 75
    error('F_net: All elements of the second argument must be between -75 degrees and +75 degrees');
end

% Check that the third and fourth input is a struct
if isstruct(rover) ~=1 || isstruct(planet) ~= 1
    error('third and fourth inputs must be structs');
end

% Main code
Fd  = F_drive(omega_motor, rover);
Frr = F_rollingCorr(omega_motor, terrain_angle, rover, planet);
Fgt = F_gravity(terrain_angle, rover, planet);

F = Fd - Frr - Fgt;
