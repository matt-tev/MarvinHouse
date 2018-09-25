function tau = tau_dcmotor(omega,motor)
    %   Function tau_dcmotor takes input1 omega(vector) and input2 motor(struct)
    %   and output tau which is the effective torque of the motor
    wNL = motor.speed_noload;
    tauS = motor.torque_stall;
    tauNL = 0;
    if nargin ~= 2 
        error('There is not 2 inputs.');
    elseif ~isvector(omega)
        error('Omega is not a vector.');
    elseif ~isstruct(motor)
        error('Motor is not a struct.');
    else
        % PROBABLY WRONG
        if omega > 0 && omega < wNL
            tau = tauS-((tauS-tauNL)/wNL)*omega;
        elseif omega < 0
            tau = tauS;
        elseif omega > wNL
            tau = 0;
        end
    end
end