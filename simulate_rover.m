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
    
    % options are dependent on end_event criteria to stop the solution of
    % the roverdynamics differential equation
    options = odeset('Events',@(t,y)end_of_mission_event(t,y,end_event));
    
    % ode15s is used to solve the rover_dynamics because it is a stiff
    % equation and not easily solvable by ode45
    [Time,state] = ode15s(@(t,y) rover_dynamics(t, y, rover, planet, experiment),experiment.time_range,experiment.initial_conditions,options);
    
    % converting the state vector into respective velocity and position
    % vectors
    velocity = state(:,1);
    position = state(:,2);
    
    % Populating Telemetry
    rover.telemetry.Time = Time;
    rover.telemetry.velocity = velocity;
    rover.telemetry.position = position;
    rover.telemetry.completion_time = Time(end); % completion time is the last point in the Time vector
    rover.telemetry.distance_traveled = abs(trapz(Time,velocity)); % distance traveled is the absolute value of the integral of velocity
    rover.telemetry.max_velocity = max(velocity); % max velocity is the maximum value in the velocity vector
    rover.telemetry.average_velocity = rover.telemetry.distance_traveled/rover.telemetry.completion_time; %avg vel is distance traveled / time elapsed
    rover.telemetry.power = mechpower(velocity,rover); % instantaneous power outputted at each point in Time
    rover.telemetry.battery_energy = battenergy(transpose(Time),transpose(velocity),rover); % total battery energy consumed throughout experiment
    rover.telemetry.energy_per_distance = rover.telemetry.battery_energy/rover.telemetry.distance_traveled; % energy per distance is energy consumed / distance traveled
end