function [t,Y,edl_system] = simulate_edl(edl_system,planet,mission_events,tmax,ITER_INFO)
% simulate_edl
%
% This file simulates the EDL system. It requires a definition of the
% edl_system, the planet, the mission events, a maximum simulation time and
% has an optional flag to display detailed iteration information.
%
% This is a horrible example of a header comment. It should be improved.
%
%


if nargin<4
    error('minimum inpus is 4');
end
if nargin<5
    ITER_INFO = false;
end

% handle to events function for edl simulation
h_edl_events = @(t,y) edl_events(t,y,edl_system,mission_events);


% options struct. NonNegative option declares that fuel_mass cannot go
% negative.
options = odeset('event',h_edl_events);%,'NonNegative',3);

% simulation time span
tspan = [0,tmax];

% initial state of system
y0 = [
    edl_system.velocity
    edl_system.altitude 
    edl_system.rocket.initial_fuel_mass*edl_system.num_rockets
    0
    0
    0
    0
    ];

% *** NOTE: This does not yet check for whether the fuel runs out...
if ITER_INFO
    fprintf('Commencing simulation run...\n');
end

% declare our variables (just empty arrays)
t = [];
Y = [];
TERMINATE_SIM = false;
while ~TERMINATE_SIM
    
    % run simulation until an event occurs 
    % ode113 appears to behaive better than ode45 for certain parameter
    % values
    [t_part,Y_part,TE,YE,IE] = ode113(@(t,y)edl_dynamics(t,y,edl_system, planet),tspan,y0,options);
%     [t_part,Y_part,TE,YE,IE] = ode45(@(t,y)edl_dynamics(t,y,edl_system, planet),tspan,y0,options);


% % add edl telemetry -----------%
%   edl_system.telemetry.time         =[edl_system.telemetry.time         t_part'];
%   edl_system.telemetry.altitude     =[edl_system.telemetry.altitude     edl_system.altitude];
%   edl_system.telemetry.velocity     =[edl_system.telemetry.velocity     edl_system.velocity];
%   %edl_system.telemetry.acceleration =[edl_system.telemetry.acceleration (1/6)*(F(1,1) + 2*F(1,2) + 2*F(1,3) + F(1,4))];
%   %edl_system.telemetry.total_mass   =[edl_system.telemetry.total_mass   edl_system.total_mass ];
%   %edl_system.telemetry.Force        =[edl_system.telemetry.Force   edl_system.total_mass*(1/6)*(F(1,1) + 2*F(1,2) + 2*F(1,3) + F(1,4)) ];
%   %edl_system.telemetry.fuel_mass    =[edl_system.telemetry.fuel_mass edl_system.rocket.fuel_mass ];
%   %edl_system.telemetry.rover_position = [edl_system.telemetry.rover_position edl_system.rover.position ];
%   %edl_system.telemetry.rover_velocity  = [edl_system.telemetry.rover_velocity edl_system.rover.velocity ];
% % -----------------------------%


    % process the event and update the edl_system accordingly. Also sets
    % the initial conditions for the next stage (in y0) and the
    % TERMINATE_SIM flag.
    [edl_system, y0, TERMINATE_SIM] = update_edl_state(edl_system,TE,YE,IE,Y_part,ITER_INFO);
    
    % update the simulation time span for the next stage
    tspan = [t_part(end),tmax];
    
    % appending to grow an array is inefficient, but there is no way to
    % know in advance how many elements we'll need due to the adaptive step
    % size in ode45
    t = [t; t_part];
    Y = [Y; Y_part];
    
    % This looks for whether we're out of time. other termination
    % conditions checked in update_edl_state
    if tspan(1)>=tspan(2)
        TERMINATE_SIM = true;
    end

end

    




