%rover_tester

planet = struct('g',{3.72});

end_event.max_distance = 50;
end_event.max_time = 5000;
end_event.min_velocity = 0.01;

power_subsys = struct('mass', {90});

science_payload = struct('mass', {75});

chassis.mass = 659;

motor.torque_stall = 170;
motor.torque_noload = 0;
motor.speed_noload = 3.80;
motor.mass = 5.0;
motor.effcy_tau = [0 10 20 40 75 165];
motor.effcy = [0 0.60 0.75 0.73 0.55 0.05];

speed_reducer.type = 'reverted';
speed_reducer.diam_pinion = 0.04;
speed_reducer.diam_gear = 0.07;
speed_reducer.mass = 1.5;

wheel.radius = 0.3;
wheel.mass = 1.0;
wheel_assembly.wheel = wheel;
wheel_assembly.speed_reducer = speed_reducer;
wheel_assembly.motor = motor;



%telemetry.Time;
%telemetry.completion_time;
%telemetry.velocity
%telemetry.position
%telemetry.distance_traveled

rover.wheel_assembly = wheel_assembly;
rover.chassis = chassis;
rover.science_payload = science_payload;
rover.power_subsys = power_subsys;
%rover.telemtry = telemetry;



omega = [0 0.5 1 2 3 3.8];
%terrain_angle = [10 20 30 45 -45 60];
