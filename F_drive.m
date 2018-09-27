function Fd = F_drive(omega, rover)
    %   Function F_drive takes input omega(vector) and input rover(struct)
    %   and outputs Fd, which is the driving force outputted from the rover
    Fd = zeros(1,length(omega));
    
    if nargin ~= 2
        error('There must be two input arguments.');
    elseif ~isvector(omega)
        error('Omega must be a scalar or vector.');
    elseif ~isstruct(rover)
        error('Rover must be a struct.')
    else
        %PROBABLY NOT RIGHT
        tau = tau_dcmotor(omega, rover.wheel_assembly.motor);
        %needs to be 'vectorized'
        for i = 1:length(omega)
            Fd(i) = 6*(tau(i)./rover.wheel_assembly.wheel.radius);
        end
    end
    
end
