%study_parachute_size
clc;clear;
% Define all structs
define_edl_system;
define_planet;
define_mission_events;
% Define Initial Conditions
edl_system.altitude = 11000;
edl_system.velocity = -578;
edl_system.rocket.on = false;
edl_system.parachute.deployed = true;
edl_system.parachute.ejected = false;
edl_system.heat_shield.ejected = false;
edl_system.sky_crane.on = false;
edl_system.speed_control.on = false;
edl_system.postion_control.on = false;
%idk about these next 2 lines
edl_system.rover.on_ground = false;
tmax = 2000;
edl_system_default = edl_system;

% Define vector of diameters to be tested
diameter = 14:0.5:19;
% Initialize success boolean vector to false
success(1:length(diameter)) = false;
% Prealocate completion time and velocity
comp_t = zeros(1,length(diameter));
comp_v = zeros(1,length(diameter));

for i = 1:length(diameter)
    % Set diameter to new value
    edl_system.parachute.diameter = diameter(i);
    % Simulate the mission, set final value in call to true if feedback
    % desired
    [t,Y,edl_system] = simulate_edl(edl_system,mars,mission_events,tmax,false);
    
    % Conditional to determine if success or failure
    if edl_system.rover.on_ground == true
        % rover_touchdown_speed = speed + rover_rel_vel;
        rover_touchdown_speed = Y(end,1) + Y(end,6);
        % Determine if landing was succesful      
        if Y(end,2) >=edl_system.sky_crane.danger_altitude && abs(rover_touchdown_speed)<=abs(edl_system.sky_crane.danger_speed)
            success(i) = true;
        end
    end
    
    % Finds completion time for each iteration as comp_t
    comp_t(i) = t(end);
    % Finds final velocity for each iteration as comp_v
    comp_v(i) = Y(end,1) + Y(end,6);
    
    % Reset values for next iteration
    t = [];
    Y = [];
    edl_system = edl_system_default;
end
% Plot data collected
subplot(3,1,1)
plot(diameter,comp_t)
yticks([0 100 200 300 400]);
xlabel('Parachute Diameter (m)');
ylabel('Simulated Time (s)');
title('Simulated Time vs. Parachute Diameter');
grid on;

subplot(3,1,2);
plot(diameter,comp_v);
yticks([ -100 -75 -50 -25 0]);
ylim([-105 5]); % expand axis for visual benefit
xlabel('Parachute Diameter (m)');
ylabel('Landing Speed (s)');
title('Rover Speed at Termination vs. Parachute Diameter');
grid on;


subplot(3,1,3)
scatter(diameter,success,'Filled');
yticks([0 1]);
yticklabels({'Failure','Success'}) % Label Succes and Failure
xlim([14.9 19.1]); % expand axis for visual benefit
ylim([-0.1 1.1]); % expand axis for visual benefit
xlabel('Parachute Diameter (m)');
ylabel('Landing Success');
title('Rover Landing Success vs. Parachute Diameter');
grid on;