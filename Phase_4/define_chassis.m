function edl_system = define_chassis(edl_system, type)
% define_batt_pack
%
% Determines the attributes of the rover motor. Returns edl_system with
% properly modified motor.
%
% INPUTS:
%    edl_system and type of chassis:
%       steel, magnesium, carbon fiber
%
% OUTPUTS
%   edl_system
% 
% Notes: 
%   

if nargin<2
    error('define_chassis: requires edl_system and type inputs');
end

chassis=edl_system.rover.chassis;

if strcmpi(type,'steel')
    chassis.type = 'steel';
    chassis.specific_strength=100;
elseif strcmpi(type,'magnesium')
    chassis.type = 'magnesium';
    chassis.specific_strength=250;    
elseif strcmpi(type,'carbon')
    chassis.type = 'carbon';
    chassis.specific_strength=1000;
else
    error('input not recognized'); 
end
  
chassis.strength=chassis.mass*chassis.specific_strength;

edl_system.rover.chassis=chassis;

