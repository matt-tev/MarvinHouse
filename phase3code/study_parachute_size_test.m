%study_parachute_size
clc;clear;
ITER_INFO = true;
% Call scripts to fully define variables
define_edl_system;
define_planet;
define_mission_events;

% Setting Initial Conditions
edl_system.altitude = 11000;
edl_system.velocity = -578;
edl_system.rocket.on = false;
edl_system.parachute.deployed = true;
edl_system.parachute.ejected = false;
edl_system.heat_shield.ejected = false;
edl_system.sky_crane.on = false;
edl_system.speed_control.on = false;
edl_system.postion_control.on = false;

% Unsure about these lines
edl_system.rover.on_ground = false;
tmax = 2000;

% Setting vector of diameters
diameter = 14:0.5:20;

TERMINATE_SIM = false;

for i = 1:length(diameter)
    success(i) = false;
    % set for iterative diameter check
    edl_system.parachute.diameter = diameter(i);
    
    % run simulation until an event occurs 
    [t,Y,edl_system] = simulate_edl(edl_system,mars,mission_events,tmax,true);
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


% declare our variables (just empty arrays)
t = [];
Y = [];
TERMINATE_SIM = false;
while ~TERMINATE_SIM
    
    % run simulation until an event occurs 
    % ode113 appears to behaive better than ode45 for certain parameter
    % values
    [t_part,Y_part,TE,YE,IE] = ode113(@(t,y)edl_dynamics(t,y,edl_system, mars),tspan,y0,options);
%     [t_part,Y_part,TE,YE,IE] = ode45(@(t,y)edl_dynamics(t,y,edl_system, planet),tspan,y0,options);

        % process the event and update the edl_system accordingly. Also sets
        % the initial conditions for the next stage (in y0) and the
        % TERMINATE_SIM flag.
                            %[edl_system, y0, TERMINATE_SIM] = update_edl_state(edl_system,TE,YE,IE,Y_part,ITER_INFO);
% update_edl
%
% update status of EDL System based on simulation events
%
% 1. Reached altitude to eject heat shield 
% 2. Reached altitude to eject parachute 
% 3. Reached altitude to turn on rockets 
% 4. Reached altitude to turn on crane
% 5. Out of fuel --> y(3)<=0. Terminal. Direction: -1.
% 6. EDL System crashed at zero altitude
% 7. Reached speed at which controlled descent is required
% 8. Reached altitude at which position control is required
% 9. Rover has touched down on surface of Mars
%
% This also updates the rocket mass (due to fuel having been expelled).
%


% fprintf('\nIn update_edl_state. IE says:\n');
% IE=IE
% fprintf('there are %d events\n',length(IE));

% default initial conditions are final conditions of prior time interval.
y0 = Y_part(end,:);

% this updates the per rocket fuel mass in the edl_system struct
edl_system.rocket.fuel_mass = y0(3)/edl_system.num_rockets; 
edl_system.altitude = y0(2);
edl_system.velocity = y0(1);

TERMINATE_SIM = false;
num_events = length(IE);
for j=1:num_events
    
%     fprintf('\tHandling event %d. Event ID %d, time = %f\n',i,IE(i),TE(i));
    
    event = IE(j);
    time = TE(j);
    altitude = YE(j,2);
    speed = YE(j,1);
    rover_rel_pos = YE(j,7);
    rover_rel_vel = YE(j,6);
    
    switch event
        
        % heat shield eject
        case 1
            
            if ~edl_system.heat_shield.ejected 
                edl_system.heat_shield.ejected = true;
                if ITER_INFO 
                    fprintf('Ejecting heat shield at t=%f [s]\taltitude = %f [m]\tspeed = %f [m/s]\n',time,altitude,speed);
                end
                y0 = Y(end,:);
            end
            
        % parachute eject case
        case 2
            
            if ~edl_system.parachute.ejected
                edl_system.parachute.ejected = true;
                if ITER_INFO
                    fprintf('Ejecting parachute at t=%f [s]\taltitude = %f [m]\tspeed = %f [m/s]\n',time,altitude,speed);
                end
                y0 = Y(end,:);                                
            end
            
        % turning on rockets, but w/o control    
        case 3
            
            if ~edl_system.rocket.on
                edl_system.rocket.on = true;
                edl_system.rocket.control.on = false;
                if ITER_INFO
                    fprintf('Turning on rockets at t=%f [s]\taltitude = %f [m]\tspeed = %f [m/s]\n',time,altitude,speed);
                end
                y0 = Y(end,:);
            end
        
        % turn on sky crane if we're low enough (triggers event 4) and
        % we're under a position-controlled regime
        case 4
            if ~edl_system.sky_crane.on && edl_system.position_control.on
                edl_system.sky_crane.on = true;                
                if ITER_INFO
                    fprintf('Turning on sky crane at t=%f [s]\taltitude = %f [m]\tspeed = %f [m/s]\n',time,altitude,speed);
                end
                y0 = Y(end,:);
                y0(6) = edl_system.sky_crane.velocity;
            end
            
        % we're out of rocket fuel!
        case 5
             if edl_system.rocket.on
                edl_system.rocket.on = false;
                if ITER_INFO
                    fprintf('Ran out of rocket fuel at t=%f [s]\taltitude = %f [m]\tspeed = %f [m/s]\n',time,altitude,speed);
                end
                y0 = Y(end,:);
                y0(3) = 0; % no more fuel!
                TERMINATE_SIM = true;
             end      
             
        % edl crashed before sky crane is activated    
        case 6
            fprintf('EDL SYSTEM CRASHED INTO MARS AT t=%f [s]\taltitude = %f [m]\tspeed = %f [m/s]\n',time,altitude,speed);
             y0 = [];
             TERMINATE_SIM = true;
                
                
        % still descending, but slow enough to turn on speed controller
        case 7
            if ~edl_system.speed_control.on && ~edl_system.position_control.on
                edl_system.speed_control.on = true;
                if ITER_INFO
                    fprintf('Turning on speed control at t=%f [s]\taltitude = %f [m]\tspeed = %f [m/s]\n',time,altitude,speed);
                end
                y0 = Y(end,:);
                y0(4) = 0;
                y0(5) = 0;
            end
        
        % now we're low enough to activate the altitude control (and turn off speed control)    
        case 8
            if ~edl_system.position_control.on
                edl_system.speed_control.on = false;
                edl_system.position_control.on = true;
                if ITER_INFO
                    fprintf('Turning on altitude control at t=%f [s]\taltitude = %f [m]\tspeed = %f [m/s]\n',time,altitude,speed);
                end
                y0 = Y(end,:);
                y0(4) = 0;
                y0(5) = 0;
            end
            
        % we're determined the rover position is at 0 altitude (on the ground)    
        case 9
            % need to make sure we didn't trip this event accidentally
            % (e.g., rover on ground but only becuase entire craft crashed)
            if edl_system.sky_crane.on
                
                rover_touchdown_speed = speed + rover_rel_vel;
                
                if altitude>=edl_system.sky_crane.danger_altitude && abs(rover_touchdown_speed)<=abs(edl_system.sky_crane.danger_speed)
                    if ITER_INFO
                        fprintf('The rover has landed!\n\t>>> t=%f [s]\trover pos = %f [m]\t rover speed = %f [m/s] (sky crane at h=%f\tv=%f\n',time,altitude+rover_rel_pos,speed+rover_rel_vel,altitude,speed);
                    end
                    succes(i) = 1;
                    y0 = [];
                    TERMINATE_SIM = true;
                    edl_system.sky_crane.on = false;
                    edl_system.rover.on_ground = true;
                elseif altitude<edl_system.sky_crane.danger_altitude
                    if ITER_INFO
                        fprintf('EDL SYSTEM FAIL. Rover has landed, but possible damage due to sky crane low altitude.\n\t>>> t=%f [s]\trover pos = %f [m]\t rover speed = %f [m/s] (sky crane at h=%f\tv=%f\n',time,altitude+rover_rel_pos,speed+rover_rel_vel,altitude,speed);
                    end
                    y0 = [];
                    TERMINATE_SIM = true;
                    edl_system.sky_crane.on = false;
                    edl_system.rover.on_ground = true;
                elseif abs(rover_touchdown_speed)>abs(edl_system.sky_crane.danger_speed)
                    if ITER_INFO
                        fprintf('EDL SYSTEM FAIL. Rover has landed, but possible damage due to touch down speed.\n\t>>> t=%f [s]\trover pos = %f [m]\t rover speed = %f [m/s] (sky crane at h=%f\tv=%f\n',time,altitude+rover_rel_pos,speed+rover_rel_vel,altitude,speed);
                    end
                    y0 = [];
                    TERMINATE_SIM = true;
                    edl_system.sky_crane.on = false;
                    edl_system.rover.on_ground = true;
                end
            end
                
            
        otherwise
            error('unknown event encountered in EDL System simulation');
    end
    
end
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
        %[edl_system, y0, TERMINATE_SIM] = update_edl_state(edl_system,TE,YE,IE,Y_part,true);

    % Finds completion time for each iteration as comp_t
    comp_t(i) = t(end);
    % Finds final velocity for each iteration as comp_v
    comp_v(i) = Y(end,1);
end

subplot(3,1,1)
plot(diameter,comp_t)
xlabel('Parachute Diameter (m)');
ylabel('Simulated Completion Time (s)');

subplot(3,1,2);
plot(diameter,comp_v);
xlabel('Parachute Diameter (m)');
ylabel('Rover Landing Speed (s)');


subplot(3,1,3)
plot(diameter,success);
xlabel('Parachute Diameter (m)');
ylabel('Rover Landing Success');

