function F = F_net(omega,terrain_angle,rover,planet, Crr)
    %   Function F_rolling takes input1 omega(vector),input2 terrain_angle
    %   (vector), input3 rover(struct), input4 planet(struct), and input5
    %   Crr(vector) and outputs F which is the net force acting on the
    %   rover summed from the force of gravity (Fgt), the rolling force
    %   (Frr), and the force of the driving motors (Fd)

    if nargin ~= 5
        error('There must be 5 inputs.');
    elseif ~isvector(omega) || ~isvector(terrain_angle)
        error('The first two input arguments must be scalars or vectors');
    elseif terrain_angle > 75 || terrain_angle < -75
        error('The variable terrain_angle must be between the values of -75 degrees and 75 degrees.');
    elseif ~isstruct(rover) || ~isstruct(planet)
        error('The thrid and fourth input arguments must be structs.');
    elseif ~isvector(Crr) || Crr < 0
        error('The fifth input must be a positive scalar.');
    else
        %PROBABLY NOT RIGHT
        for i = 1:length(omega)
            F(i) = F_drive(omega(i),rover)+ ...
                F_rolling(omega(i),terrain_angle,rover,planet,Crr) + ... 
                    F_gravity(terrain_angle,rover,planet);
        end
    end
end