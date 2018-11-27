function[Frr]=F_rollingCorr(omega_motor, terrain_angle, rover, planet)
% F_rollingCorr.m
% Inputs:          omega_motor:    N-element array    : motor speeds [rad/s]
%                  terrain_angle:  N-element array    : terrain angles [deg]
%                  rover:          struct             : Defines rover
%                  planet:         struct             : Defines planet
%
% Outputs:           Frr:  array   Array of forces [N]

% Check that 4 inputs have been given.
if nargin ~= 4
    error('F_rollingCorr:  Incorrect number of inputs.  There should be four inputs.');
end

% Check that the first two inputs are scalars or vectors 
if any(~isnumeric(omega_motor)) || any(~isvector(omega_motor))
    error('F_rollingCorr: first input argument must be a vector of numeric values for motor speed [rad/s]');
end
if any(~isnumeric(terrain_angle)) || any(~isvector(terrain_angle))
    error('F_rollingCorr: second input argument must be a vector of numeric values for terrain angle [deg]');
end

% Check that all elements of the second argument are between -75 degrees
% and +75 degrees
if max(abs(terrain_angle)) > 75
    error('F_rollingCorr: All elements of the second argument must be between -75 degrees and +75 degrees');
end

% Check that the third and fourth input is a struct
if isstruct(rover) ~=1 || isstruct(planet) ~= 1
    error('F_rollingCorr: third and fourth inputs must be structs');
end


% Main code
m_rover = get_mass_rover(rover);
g_mars  = planet.g;
r = rover.wheel_assembly.wheel.radius;
Fn      = m_rover*g_mars*cosd(terrain_angle);

% compute rolling resistance
Crr = sqrt(0.0005/r) + 0.05;

Frr_simple_wheel = -Crr*(1/6)*Fn;  % Be wary of sign
Frr_simple = 6*Frr_simple_wheel;

Ng=get_gear_ratio(rover.wheel_assembly.speed_reducer);
omega_out = omega_motor/Ng;
v_rover = r*omega_out;

Frr = erf(40*v_rover).*Frr_simple;


