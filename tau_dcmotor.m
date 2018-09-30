function tau = tau_dcmotor(omega,motor)
    %   Function tau_dcmotor takes input1 omega(vector) and input2 motor(struct)
    %   and output tau which is the effective torque of the motor
    tau = zeros(1,length(omega));
    
    wNL = motor.speed_noload;
    tauS = motor.torque_stall;
    tauNL = motor.torque_noload;
    
    
    if nargin ~= 2 
        error('There is not 2 inputs.');
    elseif ~isvector(omega)
        error('Omega is not a vector.');
    elseif ~isstruct(motor)
        error('Motor is not a struct.');
    else
        for i = 1:length(omega)
            if omega(i) > 0 && omega(i) < wNL
                tau(i) = tauS-((tauS-tauNL)/wNL)*omega(i);
            elseif omega(i) < 0
                tau(i) = tauS;
            elseif omega(i) > wNL
                tau(i) = 0;
            end
        end
    end
end