function edl_system = define_motor(edl_system, type)
% define_motor
%
% Determines the attributes of the rover motor. Returns edl_system with
% properly modified motor.
%
% INPUTS:
%    edl_system and type of motor:
%       base, base_he, torque, torque_he, speed, speed_he
%
% OUTPUTS
%   edl_system
%   type : string = {'base', 'base_he', 'torque', 'torque_he', 'speed',
%   'speed_he'}
% Notes: 
%   


if nargin<2
    error('define_motor: requires edl_system and type inputs');
end

motor=edl_system.rover.wheel_assembly.motor;


if strcmpi(type,'base')
    motor.type = 'base';
    motor.torque_stall=165;
    motor.speed_noload=3.85;
    motor.cost=2.5e5;
elseif strcmpi(type,'base_he')
    motor.type = 'base_he';
    motor.torque_stall=165;
    motor.speed_noload=3.85;
    motor.cost=2.8e5;
    motor.effcy=motor.effcy*1.15;
    motor.effcy_tau = motor.effcy_tau*1.15;
elseif strcmpi(type,'torque')
    motor.type = 'toruqe';
    motor.torque_stall=165*1.25;
    motor.speed_noload=3.85;
    motor.cost=3e5;
elseif strcmpi(type,'torque_he')
    motor.type = 'torque_he';
    motor.torque_stall=165*1.25;
    motor.speed_noload=3.85;
    motor.cost=3.36e5;
    motor.effcy=motor.effcy*1.15;
    motor.effcy_tau = motor.effcy_tau*1.15;
elseif strcmpi(type,'speed')
    motor.type = 'speed';
    motor.torque_stall=165*.75;
    motor.speed_noload=3.85*2;
    motor.cost=3e5;
    motor.effcy_tau = motor.effcy_tau*.75;
elseif strcmpi(type,'speed_he')
    motor.type = 'speed_he';
    motor.torque_stall=165*.75;
    motor.speed_noload=3.85*2;
    motor.cost=3.36e5;
    motor.effcy=motor.effcy*1.15;
    motor.effcy_tau = motor.effcy_tau*.75;
else
   error('input not recognized'); 
end
    

edl_system.rover.wheel_assembly.motor=motor;


