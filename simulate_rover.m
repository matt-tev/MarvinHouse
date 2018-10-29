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
    energy_per_distance = battery_energy/distance traveled;
    
    %options = odeset('Events',@(t,y)end_of_mission_event(t,y,end_event));
    %[T,Y] = odesolver(differential equation, TSPAN, Initial Conditions, options);
    
    rover.telemetry.Time = Time;
    rover.telemetry.completion_time = completion_time;
    rover.telemetry.velocity = velocity;
    rover.telemetry.position
    rover.telemetry.distance_traveled
end