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
    
    [Time,state] = ode15s(@(t,y) rover_dynamics(t, y, rover, planet, experiment),experiment.time_range,experiment.initial_conditions,options);
     
    velocity = state(:,1);
    position = state(:,2);
    
    %populating telemetry
    rover.telemetry.Time = Time;
    rover.telemetry.velocity = velocity;
    rover.telemetry.position = position;
    
    rover.telemetry.completion_time = Time(end);
    rover.telemetry.distance_traveled = abs(trapz(Time,velocity));
    rover.telemetry.max_velocity = max(velocity);
    rover.telemetry.average_velocity = rover.telemetry.distance_traveled/rover.telemetry.completion_time;
    rover.telemetry.power = mechpower(velocity,rover);
    rover.telemetry.battery_energy = battenergy(transpose(Time),transpose(velocity),rover);
    rover.telemetry.energy_per_distance = rover.telemetry.battery_energy/rover.telemetry.distance_traveled;
end