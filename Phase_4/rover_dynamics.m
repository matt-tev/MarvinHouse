function[dydt]=rover_dynamics(t,y,rover,planet,experiment)
% rover_dynamics.m
%
% Dynamics of Rover.
% Returns derivative of state vector. 
% State vector: y=[vel;pos]; ydot=[accel;vel]
% 
% INPUTS
%   t : time value
%   y : 2x1 state vector
%   rover : struct defining rover
%   planet : struct defining planet
%   experiment : struct defining simulation experiment
% RETURNS:
%   dydt : 2x1 derivative of state vector
%

%Crr = experiment.crr;

% state of the rover
rover_vel = y(1);
rover_pos = y(2);

% solve for terrain angle using cubic spline interpolation
terrain_angle = interp1(experiment.alpha_dist,experiment.alpha_deg,rover_pos,'spline');

% calculate motor speed using current velocity estimate
omega_motor = motorW(rover_vel,rover);

% calculate Fnet using current motor speed and terrain angle
Fnet=F_net(omega_motor, terrain_angle, rover, planet);
m_rover  = get_mass_rover(rover);

% compute derivatives of each state variable
dydt = [(1/m_rover)*Fnet; rover_vel];


