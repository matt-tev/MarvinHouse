%F_drive
function Fd = F_drive(omega, rover)
    if nargin ~= 2
        error('There must be two input arguments.');
    elseif ~isvector(omega)
        error('Omega must be a scalar or vector.');
    elseif ~isstruct(rover)
        error('Rover must be a struct.')
    else
        % function of motor shaft speed - prop o f motor, sr, and drive
        % track
        
        %needs to be 'vectorized'
        Fd = 1;
    end
    
end
