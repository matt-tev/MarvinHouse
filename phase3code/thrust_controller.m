function edl_system = thrust_controller(edl_system,planet)
% thrust_controller
%
% This function implements a PID Controller for the EDL system. Uses
% edl_system and planet structs to create a modified edl_system struct.
% Modifies fields in rocket and telemetry substructs.
%
% Calling sequence: edl_system = thrust_controller(edl_system,planet)
% Inputs:  edl_system - struct
%          planet     - struct
% Outputs: edl_system
%
%
%



% Check number of arguments:
if (nargin > 3) || (nargin < 2)
   error('THRUST CONTROLLER: incorrect number of arguments. needs 2 (edl_system and planet)') 
end

if ~isstruct(edl_system)
    error('THRUST CONTROLLER: first input must be a struct');
end

if ~isstruct(planet)
    error('THRUST CONTROLLER: second input must be a struct');
end



% First, check if the rocket is on and that the control is activated:
if (edl_system.rocket.control.on) && (edl_system.rocket.on)

  % If edl_system is whithin altitude, set the target velocity to zero  
  if edl_system.altitude<edl_system.sky_crane.max_rope+10
     edl_system.rocket.control.target_velocity=0.0;
  end
  
  
  
  % Calculate the error (difference between actual and target velocity)
  e = edl_system.control.target_velocity-edl_system.velocity;
  
  % Update the error in telemetry array:
  edl_system.telemetry.error = [edl_system.telemetry.error e];
       
    
  % Set the parameters of the PID controller (Kp: proportional, 
  % Kd: derivative, Ki: integral terms)
  Kp = edl_system.control.Kp;
  Kd = edl_system.control.Kd;
  Ki = edl_system.control.Ki;    
   
  %e     = edl_system.telemetry.error(end);
  dt    = edl_system.telemetry.time(end)-edl_system.telemetry.time(end-1);
  ei    = edl_system.telemetry.error(end);
  eim1  = edl_system.telemetry.error(end-1);
  eim2  = edl_system.telemetry.error(end-2);
  % Calculate the derivative of the error wrt time
  dedt  = (3*ei-4*eim1+eim2)/2/dt;
  
  % Integrate the error:
  ie    = trapz(edl_system.telemetry.time,edl_system.telemetry.error);
  
  
  
  
  % *****************
  % Compute Needed Thrust
  % Two-step process: (1) compute thrust using model, (2) apply corrections
  % as needed due to saturating rocket capabilities.
  
  % Calculate the required thrust from model
  edl_system.rocket.thrust = Kp*e + Kd*dedt + Ki*ie + ...
      edl_system.total_mass*sign(planet.gravity)*planet.gravity/edl_system.rocket.number_of_rockets;
   
  % check to see if we're over or under the limits of the rocket motors
  if abs(edl_system.rocket.thrust) > abs(edl_system.rocket.max_thrust)
      % got to here? Asking for more thrust than rocket can give, so model
      % it as though we've hit the motor max thrust.
      edl_system.rocket.thrust = ...
           sign(edl_system.rocket.thrust)*edl_system.rocket.max_thrust;
  
  elseif abs(edl_system.rocket.thrust) < abs(edl_system.rocket.min_thrust)
      % got to here? Asking for less thrust than we can deliver (e.g.,
      % cannot thrust in both directions; can't turn rockets on then off
      % then back on. So knock it down to min thrust.
      edl_system.rocket.thrust = ...
          sign(edl_system.rocket.thrust)*edl_system.rocket.min_thrust;
  end
    
  
    
elseif edl_system.rocket.on && (edl_system.rocket.control.on==false)
    
    % if we get to this clause, it means the rockets are on but the
    % controller is not. In this case, we go with a     
    edl_system.rocket.thrust = edl_system.rocket.fixed_thrust;
    edl_system.telemetry.error = [edl_system.telemetry.error 0];
    %edl_system.telemetry.thrust =[edl_system.telemetry.thrust edl_system.rocket.thrust];
else
    edl_system.telemetry.error = [edl_system.telemetry.error 0];
    %edl_system.rocket.thrust = 0.0;
    %edl_system.telemetry.thrust =[edl_system.telemetry.thrust edl_system.rocket.thrust];  
end

if edl_system.rocket.on
  edl_system.telemetry.thrust =[edl_system.telemetry.thrust edl_system.rocket.thrust];
else
   edl_system.telemetry.thrust =[edl_system.telemetry.thrust 0];
end
   


