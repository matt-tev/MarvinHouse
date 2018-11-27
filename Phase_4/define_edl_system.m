% define_edl_system.m
%
% edl system struct definitions for project Phase 4. Run this file to
% instantiate an edl_system struct. 
%
%
% MEEN 357 - SPRING 2014
%



% gets rid of any existing struct with this name (the way I'm putting it
% together runs the risk of adding to an existing one rather than
% overwriting everything).
clear edl_system;


% state variables that get updated throughout the simulation
edl_system.altitude = 11000;
edl_system.velocity = -578;


% system-level parameters
edl_system.num_rockets = 8; % number of rockets in our system
edl_system.volume = 150;    % [m^3] volume of air displaced by EDL system


% parachute struct. includes physical definition and state information
% proper use is to set 'deployed' to false when the parachute is ejected
% (as well as 'ejected' to true) in case someone checks deployed but not
% ejected.
%
% note: to keep things simpler, we are starting the simulation from the
% point at which the parachute is first deployed. But we'll keep both
% logical variables in case we ever want to expand
% 
parachute = struct(...
    'deployed', true,...    % [boolean] true means it has been deployed but not ejected
    'ejected', false,...    % [boolean] true means parachute no longer is attached to system
    'diameter', 16.25,...   % [m] (MSL is about 16 m)
    'Cd', 0.615,...         % [-] (0.615 is nominal for subsonic)
    'mass', 185.0, ...      % [kg] (this is a wild guess--no data found
    'cost_per_A', 1e3 ...   % [$US/m^2] cost proportional to parachute area 
    );

% Rocket Struct. This defines a SINGLE rocket.
rocket = struct(...
    'on', false,...  
    'structure_mass', 8.0, ...                  % [kg] everything not fuel (guestimate)
    'initial_fuel_mass',230.0,...               % [kg]
    'cost_per_kg', 1500, ...                    % [$US/kg] rocket cost per kg of fuel
    'fuel_mass', 230.0, ...                     % [kg] current fuel mass (<= initial)
    'effective_exhaust_velocity',4500.0,...     % [m/s] (ballpark correct; lacking a good source)
    'max_thrust',3100.0, ...                    % [N] (MSL is 3100 according to wikipedia)
    'min_thrust', 40.0 ...                      % [N] (MSL is 400 according to wikipedia)
    );

speed_control = struct(...
    'on',false,...                  % [boolean] indicates whether this control mode is active
    'Kp', 2000,...                  % [-] proportional gain term
    'Kd', 20,...                    % [-] derivative gain term
    'Ki', 2500, ...                 % [-] integral gain term
    'target_velocity', -3.0 ...     % [m/s] desired descent speed
    );

position_control = struct(...
    'on',false,...                  % [boolean] indicates whether this control mode is active
    'Kp', 2000,...                  % [-] proportional gain term
    'Kd', 1000,...                  % [-] derivative gain term
    'Ki', 50, ...                   % [-] integral gain term
    'target_altitude', 7.6 ...      % [m] this needs to reflect the sky crane cable length
    );


% This is the part that lowers the rover onto the surface
% Lacking data on some aspects. Parameters tuned to yield system behavior
% similar to MSL.
sky_crane = struct(...
    'on', false,...                 % [boolean] true means lowering rover mode
    'danger_altitude', 4.5, ...     % [m] altitude at which considered too low for safe rover touch down
    'danger_speed', -1.0, ...       % [m/s] speed at which rover would impact too hard on surface
    'mass', 35.0,...                % [kg] (guesstimate)
    'area', 16.0,...                % [m^2] frontal area for drag calculations (guestimate)
    'Cd', 0.9,...                   % [-] coefficient of drag (guestimate; should be relatively high)
    'max_cable', 7.6, ...           % [m] max length of cable for lowering rover
    'velocity', -0.1 ...            % [m] speed at which sky crane lowers rover
    );


% heat shield is simple -- it's there or not and has some properties
heat_shield = struct(...
    'ejected', false,...        % [boolean] true means heat shield has been ejected from system
    'mass', 225.0, ...          % [kg] mass of heat shield (total guess)
    'diameter', 4.5, ...        % [m] (MSL heat shield was 4.5m in diam)
    'Cd', 0.35 ...              % [-] total guess
    );





% here I'm pulling in the rover from another file. I called it "marvin"
% there, so make sure to use proper name later.
define_rover;


% pack everything together and clean up the temporary substructs
% note: already added in top-level state variables
edl_system.parachute = parachute;
edl_system.heat_shield = heat_shield;
edl_system.rocket = rocket;
edl_system.speed_control = speed_control;
edl_system.position_control = position_control;
edl_system.sky_crane = sky_crane;
edl_system.rover = marvin;


clear parachute;
clear rocket;
clear speed_control;
clear position_control;
clear sky_crane;
clear heat_shield;
clear marvin;



    

