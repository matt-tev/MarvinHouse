% Function mechpower computes the instantaneous mechanical power output by
% a single DC motor at each point in a given velocity profile.
% 
% CALLING SYNTAX
%   P = mechpower(v,rover)% 
% INPUTS
%   v       array           N-element array of velocities [m/s]
%   rover   struct          Data structure containing rover parameters
% OUTPUTS
%  P    N-element array     Array of instantaneous power output of a 
%                           single motor corresponding to each element in 
%                           array v [W]
function P = mechpower(v, rover)
    % Data Validation
    if nargin ~= 2
        error('There must be two inputs.');
    elseif ~(isnumeric(v) || isvector(v))
        error('The first input must be a scalar or vector');
    elseif ~isstruct(rover)
        error('The second input must be a struct.');
    end
    % P = tau*omega
    %   where P is the mechanical power at a given instant
    %         tau is the torque output by the rover in N*m
    %         omega is the angular velocity of the motor shaft in rad/s
    P = tau_dcmotor(motorW(v,rover),rover.wheel_assembly.motor) .* motorW(v,rover);
end