% define_rover.m
%
% Rover struct definitions for project Phase 1. 
%
%
% Version History: 
%   Draft:      15 Jan 2014 - rmalak
%   Release:    
%   Revisions:
%       18 April 2014: Updated for Phase 4. Added battery, chassis details.
%
%
% MEEN 357 - SPRING 2014
%



motor = struct( ...
    'torque_stall', 165, ...    % [Nm]
    'torque_noload', 0,...      % [Nm]
    'speed_noload', 3.85,...    % [rad/s]
    'mass', 5.0, ...            % [kg]
    'cost',2.5e5, ...           % [$US]
    'effcy_tau', [0 10  20  40  75  165], ...   % [Nm]
    'effcy', [0 .60 .75 .73 .55  .05] ...       % [-]
    );

speed_reducer = struct(...
    'type', 'reverted',...
    'diam_pinion', 0.04,...         % [m]
    'diam_gear', 0.06,...           % [m]
    'mass', 1.5 ...                 % [kg]  
    );

wheel = struct(...
    'radius', 0.2,...        % [m]
    'mass', 1.0 ...           % [kg]
    );

wheel_assembly = struct(...
    'wheel', wheel,...
    'speed_reducer', speed_reducer,...
    'motor', motor ...
    );

clear wheel;
clear speed_reducer;
clear motor;

% care must be taken to keep fields in synch. Modify through define_chassis
% function.
chassis = struct(...
    'mass', 674, ...                % [kg]
    'type', 'steel', ...
    'specific_strength', 100 ...
    );
% chassis.strength = chassis.mass*chassis.specific_strength;


science_payload = struct(...
    'mass', 80 ...          % [kg]
    );


% define the battery. Update this using define_batt_pack function.
battery = struct(...
    'type', 'LiFePO4',...
    'num_modules', 10 ...
    );
% the following is for LiFePO4:
battery.mass = 3.4860*battery.num_modules;      % [kg]
battery.cost = 2.25e5*battery.num_modules;              % [$US]
battery.capacity = 0.9072e6*battery.num_modules;        % [J]


power_subsys = struct(...
    'mass', 100, ...         % [kg]    
    'battery', battery ...
    );
clear battery;

marvin = struct(...
    'on_ground', false, ...  % [Boolean] true means rover is on ground and ready to drive
    'wheel_assembly', wheel_assembly, ...
    'chassis', chassis, ...
    'science_payload', science_payload, ...
    'power_subsys', power_subsys ...
    );

clear wheel_assembly;
clear chassis;
clear science_payload;
clear power_subsys;

% At this point, the only thing defined is a rover struct with several
% sub-structs.


    
