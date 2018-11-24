%study_parachute_size
clc;clear;

define_edl_system;
define_planet;
define_mission_events;


edl_system.altitude = 11000;
edl_system.velocity = -578;
edl_system.rocket.on = false;
edl_system.parachute.deployed = true;
edl_system.parachute.ejected = false;
edl_system.heat_shield.ejected = false;
edl_system.sky_crane.on = false;
edl_system.speed_control.on = false;
edl_system.postion_control.on = false;


edl_system.rover.on_ground = false;
diameter = 14:0.5:20;


%idk about this next line
tmax = 2000;

for i = 1:length(diameter)
        [t,Y,edl_system] = simulate_edl(edl_system,mars,mission_events,tmax,true);

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
%plot(diameter,success);
xlabel('Parachute Diameter (m)');
ylabel('Rover Landing Success');
