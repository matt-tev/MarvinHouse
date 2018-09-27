%rover_tester

planet = struct('g',{3.72});
power_subsys = struct('mass', {90});
science_payload = struct('mass', {75});
chassis.mass = 659;
motor.torque_stall = 170;
motor.torque_noload = 0;
motor.speed_noload = 3.80;
motor.mass = 5.0;
speed_reducer.type = 'reverted';
speed_reducer.diam_pinion = 0.04;
speed_reducer.diam_gear = 0.07;
speed_reducer.mass = 5;
wheel.radius = 0.3;
wheel.mass = 1.0;
wheel_assembly.wheel = wheel;
wheel_assembly.speed_reducer = speed_reducer;
wheel_assembly.motor = motor;
rover.wheel_assembly = wheel_assembly;
rover.chassis = chassis;
rover.science_payload = science_payload;
rover.power_subsys = power_subsys;

omega = [0  0.5 1 2 3 -1];
terrain_angle = [10 20 30 45 -45 -60]
