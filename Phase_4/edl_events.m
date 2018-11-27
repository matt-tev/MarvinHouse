function [value, isterminal, direction] = edl_events(t,y,edl_system,mission_events)
% edl_events
%
% Defines events that occur in EDL System simulation.
%
% y = [ velocity, altitude, fuel_mass]';
%
%
% 1. Reached altitude to eject heat shield 
% 2. Reached altitude to eject parachute 
% 3. Reached altitude to turn on rockets 
% 4. Reached altitude to turn on crane & altitude control
% 5. Out of fuel --> y(3)<=0. Terminal. Direction: -1.
% 6. EDL System crashed at zero altitude
% 7. Reached speed at which speed-controlled descent is required
% 8. Reached position at which altitude control is required
% 9. Rover has touched down on surface of Mars

%
%


velocity = y(1);
altitude = y(2);
fuel_mass = y(3);
rover_rel_pos = y(7);
rover_pos = altitude + rover_rel_pos;

value = [
    altitude - mission_events.alt_heatshield_eject
    altitude - mission_events.alt_parachute_eject 
    altitude - mission_events.alt_rockets_on
    altitude - mission_events.alt_skycrane_on
    fuel_mass
    altitude
    velocity - 3*edl_system.speed_control.target_velocity   % turns on speed control
    altitude - 1.2*mission_events.alt_skycrane_on           % turns on altitude control
    rover_pos                                               % rover landing condition
    ];

isterminal = ones(length(value),1);
direction = [-1;-1;-1;-1;-1;-1;+1;-1;-1];


