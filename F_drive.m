function Fd = F_drive(omega, rover)
    %   Function F_drive takes input omega(vector) and input rover(struct)
    %   and outputs Fd, which is the driving force outputted from the rover
    
    % this next line tells the output function how many arguments to output
    % in order to be the same length as the omega input
    Fd = zeros(1,length(omega));
    
    % error check
    if nargin ~= 2
        error('There must be two input arguments.');
    elseif ~isvector(omega)
        error('Omega must be a scalar or vector.');
    elseif ~isstruct(rover)
        error('Rover must be a struct.')
    else
        tau = tau_dcmotor(omega, rover.wheel_assembly.motor);
        for i = 1:length(omega)
            Fd(i) = 6*(tau(i)./rover.wheel_assembly.wheel.radius);
        end
    end
    
end
