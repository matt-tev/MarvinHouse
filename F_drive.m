% Function F_drive computes the combined drive force, in Newtons, acting 
% on the rover due to all six wheels. 
%    
% CALLING SYNTAX
%   Fd = F_drive(omega, rover)
% INPUTS
%   omega   array       Array of motor shaft speeds [rad/s]
%   rover   struct      Data structure specifying rover parameters
% OUTPUTS
%   Fd      array       Array of drive forces [N]
function Fd = F_drive(omega, rover)
    % Data Validation
    if nargin ~= 2
        error('There must be two input arguments.');
    elseif ~isvector(omega)
        error('Omega must be a scalar or vector.');
    elseif ~isstruct(rover)
        error('Rover must be a struct.')
    end
    % this next line tells the output function how many arguments to output
    % in order to be the same length as the omega input
    Fd = zeros(1,length(omega));
    
    % call tau_dcmotor for motor specifications
    tau = tau_dcmotor(omega, rover.wheel_assembly.motor);
        for i = 1:length(omega)
            % calculate the drive force based on the motor shaft speed from
            % tau_dcmotor and the properties of the motor, speed
            % reducer from get_gear_ratio,and drive track 
            Fd(i) = 6*(tau(i).* ...
                get_gear_ratio(rover.wheel_assembly.speed_reducer)./ ...
                    rover.wheel_assembly.wheel.radius);
        end
    
    
end
