function[E] = battenergy(v,t,rover)
% battenergy.m
%
% Computes the total electrical energy output by the battery pack, which
% powers *both* DC motors, given the simulation profile defined by t and v.
% This function accounts for the inefficiencies of transforming electrical
% energy to rotational mechanical energy.
%
% INPUTS
%   t       : N-element array   : time profile data [s]
%   v       : N-element array   : velocity profile data [m/s]
%   rover   : struct            : struct specifying a rover
%
% OUTPUT
%   E       : scalar            : Battery energy consumed [J]
%
% 
% ASSUMPTIONS & DEPENDENCIES
% (1) Calls mechanical_power
% (2) Assumes motor is not being back-driven 
%

% Input validation
%
if nargin<3
    error('BATTENERGY: Needs three arguments: E = total_mechanical_energy(t,v,rover)');
end
if any(~isnumeric(t)) || any(~isvector(t))
    error('BATTENERGY: first input argument must be a vector of numeric values for rover time [s]');
end 
if any(~isnumeric(v)) || any(~isvector(v))
    error('BATTENERGY: second input argument must be a vector of numeric values for rover velocity [m/s]');
end 
if length(v)~=length(t)
    error('BATTENERGY: time and velocity arguments must be of same length');
end
if ~isstruct(rover)
    error('BATTENERGY: third argument must be  a valid rover struct');
end


% compute the mechanical power
mech_power = mechpower(v,rover);

% interpolate efficiency curve
omega_motor = motorW(v,rover);
tau_motor = tau_dcmotor(omega_motor,rover.wheel_assembly.motor);

tau_data = rover.wheel_assembly.motor.effcy_tau;
eff_data = rover.wheel_assembly.motor.effcy;
eff = interp1(tau_data,eff_data,tau_motor,'spline');
validIndices = eff>0;

batt_power = zeros(size(mech_power));
batt_power(validIndices) = mech_power(validIndices)./eff(validIndices);

% batt_power = mech_power./eff

% integrate
Emotor = trapz(t,batt_power);


%account for 6 motors
E = 6*Emotor;

