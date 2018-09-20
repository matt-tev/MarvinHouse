%tau_dcmotor

function tau = tau_dcmotor(omega,motor)
    if nargin ~= 2 
        error('There is not 2 inputs.');
    elseif ~isvector(omega)
        error('Omega is not a vector.');
    elseif ~isstruct(motor)
        error('Motor is not a struct.');
    else
        if omega > 0 && omega < omegaNL
            tau = tau;
        elseif omega <0
            tau = 0;
        else omega > omegaNL
            tau = taus;
        end
    end
end