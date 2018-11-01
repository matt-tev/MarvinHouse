% Function battenergy computes the total electric energy consumed over a
% simulation profile, defined as time-velocity pairs. This function assumes
% all six motors are driven from the same battery pack. This function also
% accounts for the inefficiencies of transforming Electrical E to
% Mechanical E using a DC motor.
%
% CALLING SYNTAX
%   E = battenergy(t,v,rover)
% INPUTS
%   t   N-element array     Array of time samples from a rover simulation [s]
%   v   N-element array     Array of rover velocity data from a simulation [m/s]
%                           rover struct Data structure containing rover definition
% OUTPUTS
%   E       scalar          Total electrical energy consumed from the rover battery pack over
%                           the input simulation profile. [J]
%  ADDITIONAL SPECIFICATIONS
%       This function will give a lower bound on energy requirments in
%       practice since it is undesirable to run batteries to zero capacity
%       as well as other ineffeciencies not analized in this project
function E = battenergy(t, v, rover)
    % Data Validation
    if nargin ~= 3
        error('There must be three inputs.');
    elseif ~(isnumeric(t) || isvector(t)) || ~(isnumeric(v) || isvector(v))
        error('The first input must be a scalar or vector');
    elseif length(t) ~= length(v)
        error('The first two inputs must be the same length');
    elseif ~isstruct(rover)
        error('The third input must be a struct.');
    end
    % Pmotor is the power of the rotating shaft at a given point in time
    % Pbatt is the power consumed by the battery at a given point in time
    % eff is the effeciency of the motor at operating torque tau
    % E is the total energy output by the motor from t0 to tf
    
    tau_data = rover.wheel_assembly.motor.effcy_tau;
    eff_data = rover.wheel_assembly.motor.effcy;
    eff = interp1(tau_data,eff_data,tau_dcmotor(motorW(v,rover),rover.wheel_assembly.motor),'spline');

    % Pmotor = tau*omega which is accomplished using mechpower
    Pmotor = mechpower(v, rover);
    % Pmotor = Pbatt*eff , which can be rearranging
    Pbatt = Pmotor./eff;
    % E can be calculated by the numerical integration of Pbatt
    E = trapz(t,Pbatt); 
    % Account for all 6 wheel assemblies
    E = 6*E;

end