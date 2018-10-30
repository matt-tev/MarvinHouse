% Function tau_dcmotor returns the motor shaft torque in N*m  given the 
% shaft speed in rad/s and the motor specifications structure (which 
% defines the no-load speed, no-load torque, and stall speed, among other things. 
%    
% CALLING SYNTAX
%   tau = tau_dcmotor(omega, motor)
% INPUTS
%   omega   array       Motor shaft speed [rad/s]
%   motor   struct      Data structure specifying motor parameters
% OUTPUTS
%   tau     array       Torque at motor shaft [Nm]. Return argument is same size as first input argument.
function tau = tau_dcmotor(omega,motor)
    % Data Validation
    if nargin ~= 2 
        error('There is not 2 inputs.');
    elseif ~isvector(omega)
        error('Omega is not a vector.');
    elseif ~isstruct(motor)
        error('Motor is not a struct.');
    end
    
    tau = zeros(1,length(omega)); % tau needs to be a vector the same length as omega
    wNL = motor.speed_noload;
    tauS = motor.torque_stall;
    tauNL = motor.torque_noload;
        
    for i = 1:length(omega)
        if omega(i) >= 0 && omega(i) <= wNL
            tau(i) = tauS-((tauS-tauNL)/wNL)*omega(i); % compute tau while omega is between 0 and 3.80 rad/s
        elseif omega(i) < 0
            tau(i) = tauS; % state tau is equal to 170 Nm while omega is less than 0
        elseif omega(i) > wNL
            tau(i) = 0; % state tau is equal to 0 while omega is greater than 3.80 rad/s
        end
    end
end