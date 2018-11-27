function[tau]=tau_dcmotor(omega, motor)
% tau_dcmotor.m
% Inputs:  omega:  array     Motor shaft speed [rad/s]
%          motor:  struct    Data structure specifying motor parameters
% Outputs:   tau:  array     Torque at motor shaft[Nm].  Return argument
%                            is same size as first input argument.

% Check that 2 inputs have been given.
if nargin ~= 2
    error('Incorrect number of inputs.  There should be two inputs.');
end

% Check that the first input is a scalar or a vector
if isnumeric(omega) ~= 1
    error('First input must be a scalar or a vector');
end

% Check that the second input is a struct
if isstruct(motor) ~=1
    error('Second input must be a struct');
end

% Main code
tau_s    = motor.torque_stall;
tau_nl   = motor.torque_noload;
omega_nl = motor.speed_noload;
tau = zeros(size(omega));
for ii = 1:length(omega)
    if omega(ii) >= 0 && omega(ii) <= omega_nl
        tau(ii) = tau_s - (tau_s-tau_nl)/omega_nl *omega(ii);
    elseif omega(ii) < 0
        tau(ii) = tau_s;
    elseif omega(ii) > omega_nl
        tau(ii) = 0;
    end
end




