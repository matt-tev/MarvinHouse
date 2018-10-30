%rover_experiment1
load experiment1
experiment.Crr = 0.1; %fixing error in experiment1
end_event.max_distance = 1000;
end_event.max_time = 10000;
end_event.min_velocity = 0.01;
rover = simulate_rover(rover, planet, experiment, end_event);

figure(1);
title('Rover Experiment 1');
subplot(3,1,1);
plot(rover.telemetry.Time,rover.telemetry.position);
title('Position (m) vs. Time (s)');
xlabel('Time (s)');
ylabel('Position (m)');
subplot(3,1,2);
plot(rover.telemetry.Time,rover.telemetry.velocity);
title('Velocity (m/s) vs. Time (s)');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
subplot(3,1,3);
plot(rover.telemetry.Time,rover.telemetry.power);
title('Power (W) vs. Time (s)');
xlabel('Time (s)');
ylabel('Power (W)');