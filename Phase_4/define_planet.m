% define_planet.m
%
% Planet struct definitions for project Phase 3. 
%
%
% Version History: 
%   Draft:      13 Mar 2014 - rmalak
%   Release:    xxx
%   Revisions:
%       none.
%
%
% MEEN 357 - SPRING 2014
%


high_altitude = struct();
high_altitude.temperature = @(altitude) -23.4 -0.00222*altitude; % [C]
high_altitude.pressure    = @(altitude) 0.699*exp(-0.00009*altitude); % [KPa]

low_altitude = struct();
low_altitude.temperature = @(altitude) -31 -0.000998*altitude; % [C]
low_altitude.pressure = @(altitude) 0.699*exp(-0.00009*altitude); % [KPa]

density = @(temperature,pressure) pressure/(0.1921*(temperature+273.15)); % [kg/m^3]


planet = struct(...
    'g', -3.72, ...              % [m/s^2]
    'altitude_threshold', 7000, ...  % [m]
    'low_altitude', low_altitude, ...
    'high_altitude', high_altitude, ...
    'density', density ...    
    );

clear high_altitude;
clear low_altitude;
clear density;