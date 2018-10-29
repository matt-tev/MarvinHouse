%rover_experiment1
load('experiment1.mat')
end_event.max_distance = 1000;
end_event.max_time = 10000;
end_event.min_velocity = 0.01;

figure;
subplot(3,1,1);
title('Position (m) vs. Time (s)');
xlabel('Time (s)');
ylabel('Position (m)');
subplot(3,1,2);
title('Velocity (m/s) vs. Time (s)');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
subplot(3,1,3);
title('Power (W) vs. Time (s)');
xlabel('Time (s)');
ylabel('Power (W)');