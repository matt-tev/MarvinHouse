function tau = tau_dcmotor(omega,motor)
    %   Function tau_dcmotor takes input1 omega(vector) and input2 motor(struct)
    %   and output tau which is the effective torque of the motor
    
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