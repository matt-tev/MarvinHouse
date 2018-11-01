% Function motorW computes the rotational speed of the motor shaft in rad/s 
% given the translational velocity of the rover and the rover struct. 
% 
% CALLING SYNTAX
%   w = motorW(v ,rover)
% INPUTS
%   v       array   N-element array of velocities [m/s]
%   rover   struct  Data structure containing rover parameters
% OUTPUTS
%   w       array   N-element array of motor speeds [rad/s]
function w = motorW(v, rover)
    %Data Validation
    if nargin ~= 2
        error('There must be two inputs.');
    elseif ~(isnumeric(v) && isvector(v))
        error('The first input must be a scalar or vector');
    elseif ~isstruct(rover)
        error('The second input must be a struct.');
    end
    % w = Ng * v / r
    % where w is the angular velocity of the output shaft in rad/s
    %       Ng  is the gear ratio found by using get_gear_ratio()
    %       v   is the velocity of the rover
    %       r   is the radius of the wheels
    w = get_gear_ratio(rover.wheel_assembly.speed_reducer)*v/rover.wheel_assembly.wheel.radius;
end