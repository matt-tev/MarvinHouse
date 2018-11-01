% rover_experiment1 is an experiment based on experiment1.mat and the
% guidlines the find position vs. time, velocity vs. time and power vs.
% time
load experiment1
experiment.Crr = 0.1; % fixing error in experiment1
end_event.max_distance = 1000;
end_event.max_time = 10000;
end_event.min_velocity = 0.01;
rover = simulate_rover(rover, planet, experiment, end_event);

% create one figure with all the plots 
figure(1);
title('Rover Experiment 1');
subplot(3,1,1); % first plot in firgure 1
plot(rover.telemetry.Time,rover.telemetry.position); % plot positon vs. time
title('Position (m) vs. Time (s)');
xlabel('Time (s)');
ylabel('Position (m)');
subplot(3,1,2); % second plot in figure 1
plot(rover.telemetry.Time,rover.telemetry.velocity); % plot velocity vs. time
title('Velocity (m/s) vs. Time (s)');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
subplot(3,1,3); % third plot in figure 1
plot(rover.telemetry.Time,rover.telemetry.power); % plot power vs. time
title('Power (W) vs. Time (s)');
xlabel('Time (s)');
ylabel('Power (W)');