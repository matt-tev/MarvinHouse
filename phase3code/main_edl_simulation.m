% main_edl_simulation
%  
% This is the top-level script for running a simulation of the EDL system.
% It loads the appropriate info into the workspace and calls simulate_edl.
% After returning from simulate_edl, it graphs some of the simulation
% trajectory data.
%
%


clear;
clc;
% close all;

% *************************************
% load structures that define the EDL system (includes rover), planet,
% mission events and so forth.
%
define_edl_system;
define_planet;
define_mission_events;

% Overrides what might be in the loaded data to establish our desired
% initial conditions
%
edl_system.altitude = 11000;    % [m] initial altitude
edl_system.velocity = -578;     % [m/s] initial velocity
edl_system.parachute.deployed = true;   % our parachute is open
edl_system.parachute.ejected = false;   % and still attached
edl_system.rover.on_ground = false; % the rover has not yet landed


edl_system.parachute.diameter = 20.0;

tmax = 2000; % [s] maximum simulated time


% the simulation. changing last argument to false turns off message echo
[t,Y,edl_system] = simulate_edl(edl_system,mars,mission_events,tmax,true);


% visualize the simulation results
figure(1);
subplot(7,1,1);
plot(t,Y(:,1));
title('velocity vs. time');
grid on;
subplot(7,1,2);
plot(t,Y(:,2));
title('altitude vs. time');
grid on;
subplot(7,1,3);
plot(t,Y(:,3));
title('fuel mass vs. time');
grid on;
subplot(7,1,4);
plot(t,Y(:,4));
title('speed error integral vs. time');
grid on;
subplot(7,1,5);
plot(t,Y(:,5));
title('position error integral vs. time');
grid on;
subplot(7,1,6);
plot(t,Y(:,6));
title('velocity of rover relative to sky crane vs. time');
grid on;
subplot(7,1,7);
plot(t,Y(:,7));
title('position of rover relative to sky crane vs. time');
grid on;


figure(2);
sky_crane_hover_pos = Y(:,2);
sky_crane_speed = Y(:,1);
ignore_indecies = sky_crane_hover_pos>2*20;
sky_crane_hover_pos(ignore_indecies) = NaN(size(sky_crane_hover_pos(ignore_indecies)));
sky_crane_speed(ignore_indecies) = NaN(size(sky_crane_speed(ignore_indecies))); 
subplot(2,1,1);
plot(t,sky_crane_speed);
title('speed of sky crane vs. time');
grid on;
subplot(2,1,2);
plot(t,sky_crane_hover_pos);
title('position of sky crane vs. time');
grid on;

