function Fd = F_drive(omega, rover)
    %   Function F_drive takes input omega(vector) and input rover(struct)
    %   and outputs Fd, which is the driving force outputted from the rover

    if nargin ~= 2
        error('There must be two input arguments.');
    elseif ~isvector(omega)
        error('Omega must be a scalar or vector.');
    elseif ~isstruct(rover)
        error('Rover must be a struct.')
    else
        %PROBABLY NOT RIGHT
        tau = tau_dcmotor(omega,motor);
        %needs to be 'vectorized'
        Fd = tau/wheel.radius;
    end
    
end
