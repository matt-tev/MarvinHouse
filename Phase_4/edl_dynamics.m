function dydt = edl_dynamics(t, y, edl_system, planet)
% edl_dynamics
%
% Dynamics of EDL as it descends and lowers the rover to the surface. 
% State vector: 
%   y=[vel_edl;pos_edl;fuel_mass;ei_vel;ei_pos;vel_rov;pos_rov]
%   ydot=[accel_edl;vel_edl;dmdt;e_vel;e_pos;accel_rov;vel_rov]
% 
% edl altitude, velocity and acceleration are absolute
% rov is relative to edl
% fuel_mass is total over all rockets
%
% 
% Note: this is a VARIABLE MASS SYSTEM, which means Newton's second law
% expressed as F=ma cannot be used. The more fundamental relationship is 
% F = dp/dt, where p is the momentum of the system. (For a particle, p=mv
% and if m is constant you recover the F=ma form easily.) It is important
% to consider the momentum contributions of the EDL system and propellant 
% being expelled from the rocket. Ultimately you end up with something that
% roughly resembles Newton's second law: F_ext + v_rel*(dm/dt) = ma where m
% is the mass of the EDL, dm/dt is the rate at which mass is changing (due
% to propellant being expelled), v_rel is the speed at which propellant is
% being expelled, a is the acceleration of the EDL and F_ext is the sum of
% other forces acting on the EDL (drag, bouyancy, gravity). Since
% v_rel*(dm/dt) is a force, we can write this as F_ext + F_thrust = ma,
% which is very Newton-like.
%
%
%


% ********************************************
% unpack the input state vector into variables with more readable names
% 
vel_edl = y(1);         % [m/s] velocity of EDL system
altitude_edl = y(2);    % [m] altitude of EDL system
fuel_mass = y(3);   % [kg] total mass of fuel in EDL system 
ei_vel = y(4);      % [m/s] error integral for velocity error 
ei_pos = y(5);      % [m] error integral for position (altitude) error 
vel_rov = y(6);     % [m/s] velocity of rover relative to sky crane
pos_rov = y(7);     % [m] position of rover relative to sky crane

% ***
% Record the current mass of the system. Since the edl_system being passed
% is the initial state system, need to update the fuel mass as we go. This
% is an artefact of how ode45 and its cousins are implemented.
edl_system.rocket.fuel_mass = fuel_mass/edl_system.num_rockets; 
edl_mass = get_mass_edl(edl_system);


% Forces EXCEPT THRUST acting on EDL System
F_ext = F_gravity_descent(edl_system,planet)+...
    F_buoyancy_descent(edl_system,planet,altitude_edl)+...
    F_drag_descent(edl_system,planet,altitude_edl,vel_edl);

% Remove comment if you want some extra debigging display
% fprintf('\n');   
% F_grav = F_gravity_descent(edl_system,planet)
% F_bouy = F_buoyancy_descent(edl_system,planet,altitude_edl)
% F_drag = F_drag_descent(edl_system,planet,altitude_edl,vel_edl)



% ***********************************************************************
% Two if statements here for the dynamical state. First one determines the
% state of the EDL system. The second determines the state of the sky crane
% operation in terms of lowering the rover. Somewhere else, it should be
% enforced that the sky crane cannot begin lowering the rover until it is
% at an appropriate and stable altitude. Here we just will do the dynamics
% of each without regard for whether we should.
% ****

% ****************
% EDL System Dynamics
if edl_system.rocket.on && ...
        ~edl_system.speed_control.on && ...
        ~edl_system.position_control.on
    
    % ** Uncontrolled (0.95*max) rocket firing
    F_thrust = 0.9*edl_system.rocket.max_thrust*edl_system.num_rockets;  % Thrust from rockets

    dy1dt = (F_ext+F_thrust)/edl_mass;    % acceleration
    dy2dt = vel_edl;                % velocity

    % Change in total mass of rockets due to propellant being expelled to
    % produce thrust. Calculate this as F_thrust/v_rel, where v_rel is the
    % effective exhaust velocity of the propellant
    dmdt = -(F_thrust/edl_system.rocket.effective_exhaust_velocity);
    
    % error signals
    e_vel = 0;
    e_pos = 0;
        
%     % A debugging message that may be commented out
%     fprintf('(t=%f) uncontrolled: thrust = %f\taltitude = %f\tvel = %f\n',t,F_thrust,altitude_edl,vel_edl);

    
elseif edl_system.rocket.on && edl_system.speed_control.on

    % ** This is the dynamical regime for when the rockets are firing 
    % ** with a speed controller    
    
    % PID gains
    Kp = edl_system.speed_control.Kp;
    Kd = edl_system.speed_control.Kd;
    Ki = edl_system.speed_control.Ki;

    
    % error and error integral -- can't compute error derivative explicitly
    % due to an implicit relationship. Error derivative, dedt, is equal to
    % dy1dt (acceleration). However, we need dedt to compute F_thrust and
    % F_thrust to compute dy1dt. So the solution is to rearrange thing
    % symbolically so that we eliminate the error derivative term.
    e_vel = edl_system.speed_control.target_velocity-vel_edl;


    num = (Kp*e_vel + Kd*(F_ext/edl_mass) + Ki*ei_vel) - edl_mass*planet.g;
    den = (1-Kd/edl_mass);
    F_thrust = num/den;

    % this ensures we never try to reverse thrust (which is impossible in
    % this system)
    F_thrust = max( edl_system.num_rockets*edl_system.rocket.min_thrust, F_thrust);

    % this checks for saturation of thrust (more than 100% of what rockets
    % can deliver)
    F_thrust = min( F_thrust, edl_system.num_rockets*edl_system.rocket.max_thrust);
    

    
%     % A debugging message that may be commented out
%     fprintf('(t=%f) e_vel = %f\tei_vel = %f\tthrust = %f\tvel = %f\n',t,e_vel,ei_vel,F_thrust,vel_edl);
      
    % acceleration and velocity, respectively
%     dy1dt = (F_ext + F_thrust*edl_system.num_rockets)/edl_mass;    
    dy1dt = (F_ext + F_thrust)/edl_mass;
    dy2dt = vel_edl;
    
    
% Different flavors of debugging messages. Uncomment to use.
%     fprintf('(t=%f) v= %f\te= %f\tei= %f\tedot= %f\n',t,vel_edl,e_vel,ei_vel,dy1dt);
%     fprintf('(t=%f) %f\t%f\t%f\t%f\t%f\tF_t= %f\talt= %f\tv= %f\te= %f\tei= %f\n',t,t1,t2,t3,t4,den,F_thrust,altitude_edl,vel_edl,e_vel,ei_vel);

    
    % Change in total mass of rockets due to propellant being expelled to
    % produce thrust. Calculate this as F_thrust/v_rel, where v_rel is the
    % effective exhaust velocity of the propellant
    dmdt = -(F_thrust/edl_system.rocket.effective_exhaust_velocity);

    % position error
    e_pos = 0;
    
elseif edl_system.rocket.on && edl_system.position_control.on

    % ** This is the dynamical regime for when the rockets are firing 
    % ** with an altitude controller    
    
    Kp = edl_system.position_control.Kp;
    Kd = edl_system.position_control.Kd;
    Ki = edl_system.position_control.Ki;

    
%     % position error and change in that error. note sign convention. 
    e_pos = edl_system.position_control.target_altitude - altitude_edl;
    dedt_pos = -vel_edl;
    
    % note: planet.g is <0 due to sign convention, so negating here gives a
    % positive valued thrust. 
    F_thrust = edl_system.num_rockets*(Kp*e_pos + Kd*dedt_pos + Ki*ei_pos) - planet.g*edl_mass;
    
    % enforces a minimum thrust level since we cannot thrust downward
    F_thrust = max(edl_system.rocket.min_thrust*edl_system.num_rockets,F_thrust);
       
    % enforces a maximum thrust level (saturation condition)
    F_thrust = min(F_thrust, edl_system.num_rockets*edl_system.rocket.max_thrust);
    
    
    % velocity and acceleration 
    dy2dt = vel_edl;      
    dy1dt = (F_ext+F_thrust)/edl_mass;
    
%     % A debigging message that may be commented out
%     fprintf('(t=%f) v= %f\talt= %f\te= %f\tdedt= %f\tei= %f\tedot= %f\t F_t= %f\n',t,vel_edl,altitude_edl,e_pos,dedt_pos,ei_pos,dy1dt,F_thrust);
%     fprintf('(t=%f)\te_pos = %f\tei_pos = %f\tthrust = %f\talt = %f\tvel = %f\n',t,e_pos,ei_pos,F_thrust,altitude_edl,vel_edl);


    % Change in total mass of rockets due to propellant being expelled to
    % produce thrust. Calculate this as F_thrust/v_rel, where v_rel is the
    % effective exhaust velocity of the propellant
    dmdt = -(F_thrust/edl_system.rocket.effective_exhaust_velocity);

     % velocity error 
    e_vel = 0; 
        
else
    
    % ** If we get here, we either have not yet fired up the rockets or we
    % ** have run out of fuel (so thrust and change in mass are zero).
    
    % update state of EDL dynamics
    dy1dt = F_ext/edl_mass;
    dy2dt = vel_edl;
      
    % since rockets are off in this dynamical regime, we simply can set dmdt=0
    dmdt = 0;
    
    % error signals
    e_vel = 0;
    e_pos = 0;
    
    
%     % A debugging message that may be commented out
%     fprintf('(t=%f) no rockets: altitude = %f\tvel = %f\n',t,altitude_edl,vel_edl);

    
end


% Sky Crane dynamics (lowering the rover)
if edl_system.sky_crane.on
    
    % this is a 1st order model. We instantaneously jump to constant
    % velocity and then stay there (the jump is handled by an initial
    % condition).
    
    dy6dt = 0; % model as constant velocity (zero accel) process
    dy7dt = edl_system.sky_crane.velocity;
    
%     fprintf('sky crane platform: h = %f\tv = %f\ta = %f\n',altitude_edl,vel_edl,dy1dt);
%     fprintf('rover status (rel): h = %f\tv = %f\ta = %f\n',pos_rov,vel_rov,dy6dt);
%     fprintf('rover status (abs): h = %f\tv = %f\ta = %f\n\n',altitude_edl+pos_rov,vel_edl+vel_rov,dy1dt-dy6dt);
    
else
    % rover relative to sky crane
    dy6dt = 0; % rover acceleration
    dy7dt = 0; % rover velocity
end


% the return vector (note that e is deidt since ei is integral of e)
dydt = [dy1dt; dy2dt; dmdt; e_vel; e_pos; dy6dt; dy7dt];

