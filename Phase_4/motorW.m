function omega_motor = motorW(v, rover)
% motorW
%
% omega_motor = motorW(v, rover) computes the rotational speed of the motor
% [rad/s] given the translational speed [m/s] of the rover and a
% rover definition struct.
%
% INPUTS: 
%   v           : N-element array : translational velocity of rover [m/s]
%   rover       : struct          : structure defining rover parameters
% 
% RETURNS:
%   omega_motor : N-element array : motor shaft speed [rad/s]
%
%


% Input validation
if nargin<2 || nargin>2
    error('MOTORW: requires two inputs: omega_motor = motorW(v, rover)');
end
if any(~isnumeric(v)) || any(~isvector(v))
    error('MOTORW: first input argument must be a vector of numeric values for rover velocity [m/s]');
end
if ~isstruct(rover)
    error('MOTORW: second input argument must be a rover struct');
end

Ng     = get_gear_ratio(rover.wheel_assembly.speed_reducer);
 r     = rover.wheel_assembly.wheel.radius;


% the conversion code
omega_motor = v*Ng/r;