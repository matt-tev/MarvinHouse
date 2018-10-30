% Function simulate_rover integrates the trajectory of a rover.
% 
% CALLING SYNTAX
%   rover=simulate_rover(rover,planet,experiment,end_event)
% INPUTS
%   rover       struct      Data structure containing the parameters of the
%                           rover
%   planet      struct      Data structure containing the planet definition
%   experiment  struct      Data structure containing parameters of the 
%                           trajectory to be followed by the rover
%   end_event   struct      Data structure containing the conditions 
%                           necessary and sufficient to terminate 
%                           simulation of rover dynamics
% OUTPUTS
%   rover       struct      Data structure containing the parameters of the  
%                           rover, including updated telemetry information.
function rover = simulate_rover(rover, planet, experiment, end_event)
    % Data Validation
    if nargin ~= 4
        error('There must be 4 inputs.');
    elseif ~(isstruct(rover) && isstruct(planet) && isstruct(experiment) && isstruct(end_event))
        error('All inputs must be structs.');
    end
    
    options = odeset('Events',@(t,y)end_of_mission_event(t,y,end_event));
    %[T,Y] = odesolver(differential equation, TSPAN, Initial Conditions, options);
    %[Time,position] = ode45(@rover_dynamics(t, y, rover, planet, experiment),experiment.time_range,experiment.initial_conditions,options);
    
    
    
    %completion_time = length(Time)*resolution
    %distance_traveled = abs(integral(velocity))
    
    power = mechpower(velocity,rover);
    battery_energy = battenergy(Time,velocity,rover);
    max_velocity = max(velocity);
    average_velocity = distance_traveled/completion_time;
    energy_per_distance = battery_energy/distance_traveled;
    
    %populating telemetry
    rover.telemetry.Time = Time;
    rover.telemetry.completion_time = completion_time;
    rover.telemetry.velocity = velocity;
    rover.telemetry.position = position;
    rover.telemetry.distance_traveled = distance_traveled;
    rover.telemetry.max_velocity = max_velocity;
    rover.telemetry.average_velocity = average_velocity;
    rover.telemetry.power = power;
    rover.telemetry.battery_energy = battery_energy;
    rover.telemetry.energy_per_distance = energy_per_distance;
end