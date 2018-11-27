function[P] = mechpower(v,rover)
% mechpower.m
%
% Computes the instantaneous mechanical power output by a *single* DC motor
% given the velocity profile, v.
%
% INPUTS
%   v       : N-element array   : velocity profile data [m/s]
%   rover   : struct            : struct specifying a rover
%
% OUTPUT
%   P       : N-element array   : instantaneous power [W]
%
% 
% ASSUMPTIONS & DEPENDENCIES
% (1) Calls motorW and dcmotor
% (2) Assumes motor is not being back-driven. 
%

% Input validation

if nargin<2
    error('MECHPOWER: requires two inputs: P = mechanical_power(v,rover)');
end

if any(~isnumeric(v)) || any(~isvector(v))
    error('MECHPOWER: first input argument must be a vector of numeric values for rover velocity [m/s]');
end 

if ~isstruct(rover)
    error('MECHPOWER: second argument must be a rover struct');
end


% note, one motor
omega_motor = motorW(v,rover);
tau_motor = tau_dcmotor(omega_motor,rover.wheel_assembly.motor);
P = tau_motor.*omega_motor;
