function edl_system = define_batt_pack(edl_system, type, num_modules)
% define_batt_pack
%
% Determines the attributes of the RevBot battery pack and returns a
% properly define battery struct.
%
% INPUTS:
%    edl_system
%    type    A string defining the type of battery technology being used.
%           Valid choices are: 
%               NiCd - Nickel Cadmium - module from AA cells
%               NiMH - Nickel Metal Hydride - module from sub-C cells
%               LiFePO4 - Lithium Iron Phosphate - Tenergy 31382
%               PbAcid-1 - Lead Acid - UPG D5722
%               PbAcid-2 - Lead Acid - UPG UB-GC2
%               PbAcid-3 - Lead Acid - Powersonic PS-12180NB
%
%   num_modules   A positive scalar integer indicating the number of
%               individual 36V modules used of the specified type of
%               battery. (Batteries come in discrete cells that you connect
%               in series to achieve a desired voltage level. Then you
%               bundle several of these in parallel to achieve the desired
%               energy storage capacity. So in our case, one "pack"
%               consists of several "modules", which itself consists of
%               several "cells".) 
%
% OUTPUTS
%   battery     A struct defining the battery pack. Includes fields for
%               cost [$], mass [kg], capacity [J], type [string], and
%               num_modules [integer>0].
%
% 
% Notes: 
%   1) I am using the term 'module' in this context to refer to several
%   cells in series as required to create 36V across the terminals. For
%   example, one would require 18 lead-acid cells and 36 NiMH cells to
%   achieve 36V. I could have defined this in terms of the individual
%   battery cells. However, rather than having you guys (ya'all?) worry
%   about volatage requirements and all that noise, I've simplified things
%   to be based in 36V increments. 
%
%   2) The 36V assumption is somewhat arbitrary on my part. Many DC motors
%   of the size we'll need do run at 36V, but they often also will run at
%   24V or 48V (and higher). To add voltage requirements into the mix would
%   complicate the problem without really adding to your learning as it
%   pertains to MEEN 357.
%

if nargin<3
    error('define_batt_pack: requires type (string) and num_modules (integer) inputs');
end

if rem(num_modules,1)~=0 || num_modules<=0
    error(['define_batt_pack: num_modules must be a positive integer; input value was ' num2str(num_modules)]);
end




if strcmpi(type,'LiFePO4')
    mass_per_module = 3.4860;        % kg
    Joules_per_module = 0.9072e5;   % Joules (7 AHr @ 36 V)
    cost_per_module = 2.25e5;          % $ (retail)
elseif strcmpi(type,'NiMH')
    % 3x Tenergy 12V module made from sub-C cell NiMH batteries
    % 5000 mAhr per module
    mass_per_module = 2.1630;        % kg           
    Joules_per_module = 0.6480e5;    % Joules (5000 mAhr @ 36V)
    cost_per_module = 125000;        % $ (retail reflecting quantity discount)
elseif strcmpi(type,'NiCD')
    % 3x 12V module made from AA cell NiCD batteries
    % 700 mAHr capacity per module
    mass_per_module = 0.669;        % kg
    Joules_per_module = 0.0906e5;   % Joules (700 mAhr @ 36V)
    cost_per_module = 25000;           % $ (retail reflecting quantity discount)
elseif strcmpi(type,'PbAcid-1')
    % 3x UPG D5722 Sealed Lead Acid
    mass_per_module = 30;        % kg
    Joules_per_module = 4.38e5;    % Joules (35 AHr @ 36V)
    cost_per_module = 150000;           % $ (full retail)
elseif strcmpi(type,'PbAcid-2')
    % UPG UB-GC2 Golf Cart/AGM Battery - Sealed Lead Acid
    % factored below at x6 since each of the above is only 6V DC
    mass_per_module   = 60;         % kg
    Joules_per_module = 8.76e5;     % Joules (200 AHr @ 36V)
    cost_per_module   = 21000;          % $ (full retail)
elseif strcmpi(type,'PbAcid-3')
    % 3x Powersonic PS-12180NB 12V 18Ah Sealed Lead Acid Battery
    mass_per_module   = 45;         % kg
    Joules_per_module = 6.57e5;    % Joules (18 AHr @ 36V)
    cost_per_module   = 170000;           % $ (full retail)
else
    error(['define_batt_pack: unknown battery type = ' type]);
end


battery.type = type;
battery.num_modules = num_modules;
battery.mass = mass_per_module*num_modules;
battery.cost = cost_per_module*num_modules;
battery.capacity = Joules_per_module*num_modules;

edl_system.rover.power_subsys.battery = battery;


