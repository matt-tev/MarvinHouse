function[value, isterminal,direction] = end_of_mission_event(t,y,end_event)
% end_of_mission_event.m
%
% Defines an event that terminates the mission simulation. Mission is over
% when rover reaches a certain distance, has moved for a maximum simulation time or has
% reached a minimum velocity.
%

mission_distance     = end_event.max_distance;
mission_max_time     = end_event.max_time;
mission_min_velocity = end_event.min_velocity;

% assume that y(2) is the distance traveled
distance_left      = mission_distance - y(2) ;
time_left          = mission_max_time - t;
velocity_threshold = y(1)-mission_min_velocity;

value = [distance_left,velocity_threshold,time_left];

isterminal = [1;1;1];

% is terminal indicates whether any of the conditions can lead to the
% termination of the ODE solver. In this case all conditions can terminate
% the simulation independently.

% direction indicates whether the direction along which the different
% conditions is reached matter or does not matter. In this case, only
% the direction in which the velocity treshold is arrived at matters
%(negative)
%
direction = [0,-1,0];