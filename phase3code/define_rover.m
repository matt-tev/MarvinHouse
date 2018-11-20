% define_rover.m
%
% Rover struct definitions for project Phase 1. 
%
%
% Version History: 
%   Draft:      15 Jan 2014 - rmalak
%   Release:    xxx
%   Revisions:
%       none.
%
%
% MEEN 357 - SPRING 2014
%


motor = struct( ...
    'torque_stall', 165, ...    % [Nm]
    'torque_noload', 0,...      % [Nm]
    'speed_noload', 3.85,...    % [rad/s]
    'mass', 5.0 ...             % [kg]
    );


% I think this one is open to some work...
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

chassis = struct(...
    'mass', 674 ...         % [kg]
    );

science_payload = struct(...
    'mass', 80 ...          % [kg]
    );


power_subsys = struct(...
    'mass', 100 ...         % [kg]
    );

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


    
