function[Fd]=F_drive(omega_motor, rover)
% F_drive.m
% Inputs:  omega_motor:  array   Array of motor shaft speeds [rad/s]
%                rover:  struct  Data structure specifying rover parameters
%
% Outputs:          Fd:  array   Array of drive forces [N]

% Check that 2 inputs have been given.
if nargin ~= 2
    error('Incorrect number of inputs.  There should be two inputs.');
end

% Check that the first input is a scalar or a vector
if isnumeric(omega_motor) ~= 1
    error('First input must be a scalar or a vector');
end

% Check that the second input is a struct
if isstruct(rover) ~=1
    error('Second input must be a struct');
end

% Main code
Ng=get_gear_ratio(rover.wheel_assembly.speed_reducer);
%omega_out = omega_motor/Ng;

tau = tau_dcmotor(omega_motor, rover.wheel_assembly.motor);
tau_out = tau*Ng;

r   = rover.wheel_assembly.wheel.radius;

% Drive force for one wheel
Fd_wheel = tau_out/r;

% Drive force for all six wheels
Fd = 6*Fd_wheel;