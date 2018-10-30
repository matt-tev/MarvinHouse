% Function rover_dynamics computes the derivitive of the state vector for
% the rover given its current state. It is inted to be passed to ode45 or a
% similar simulation function.
% 
% CALLING SYNTAX
%   dydt = rover_dynamics(t, y, rover, planet, experiment)
% INPUTS
%   t       scalar      Time sample [s]
%   y       2x1 array   Array of dependent variables (i.e., state vector). First element is rover
%                       velocity [m/s] and second element is rover position [m]
%   rover   struct      Data structure containing rover definition
%   planet  struct      Data structure containing planet definition
%                       experiment struct Data structure containing experiment definition
% OUTPUTS
%   dydt    2x1 array   First derivatives of state vector. First element is rover acceleration [m/s^2]
%                       and second element is rover velocity [m/s]
function dydt = rover_dynamics(t, y, rover, planet, experiment)
    %Data Validation
    if ~isnumeric(t) || ~isscalar(t)
        error('The first input must be a scalar.');
    elseif ~isvector(y) || (length(y) ~= 2)
         error('The second input must be a 2x1 array');
    elseif ~(logical([1 1]) == (size(y) == [2, 1]))
         error('The second input must be a 2x1 array');
    elseif ~(isstruct(rover) && isstruct(planet) && isstruct(experiment))
        error('The third through fifth inputs must be structs.');
    end
    % Maybe Done
    
    v = y(1);
    omega = motorW(v,rover);
    terrain_angle = interp1(experiment.alpha_dist,experiment.alpha_deg,y(2),'spline');
    Crr = experiment.crr; %%%Error in exeriment1.m
    accel = F_net(omega,terrain_angle,rover,planet, Crr)/get_mass(rover);
    dydt(1) = accel;
    dydt(2) = y(1);
end