function [ Cdm ] = updated_drag( edl_system, velocity, altitude )
% This function uses the edl_system function, a given velocity [m/s], and a
% given altitude [m] to find the modified coefficient of drag for the
% parachute. 

Mach=[.25,.5,.65,.7,.8,.9,.95,1,1.1,1.2,1.3,1.4,1.5,1.6,1.8,1.9,2,2.2,2.5,2.6]; % Original Mach data array
MEF=[1,1,1,.98,.9,.72,.66,.76,.9,.96,.99,.999,.992,.98,.9,.85,.82,.75,.65,.62]; % Original Mach Efficiency Factor data array

% The following line of code interpolates to find the MEF at a calculated Mach 
% Number. This is done using the given v2M_Mars function using the velocity 
% and altitude specified at the input. 

MEF2=interp1(Mach,MEF,v2M_Mars(velocity,altitude),'spline'); 
                                                             
% After the corresponding Mach Efficiency Factor is determined, it is multiplied
% by the subsonic drag coefficient to determine the modified coefficient of drag
% as done in the line oc code below. The subsonic drag coefficient is defined 
% in the edl_system structure.

Cdm=MEF2*edl_system.parachute.Cd; % This is the modified coefficient of drag.

 % The lines below proved a plot to check the modified drag doefficient
 % against the subsonic constant drag coefficient. 
 MEF3=interp1(Mach,MEF,linspace(.25,2.6,100*length(Mach)),'spline');
 
 size(Mach)
 size(edl_system.parachute.Cd*(ones(1,length(Mach))))
 size(linspace(.25,2.6,100*length(Mach)))
 size( MEF3*edl_system.parachute.Cd)
 
 plot(Mach,edl_system.parachute.Cd*(ones(1,length(Mach))),linspace(.25,2.6,100*length(Mach)), MEF3*edl_system.parachute.Cd)
 legend('Subsonic Coefficient of Drag', 'Modified Coefficient of Drag');
 title ('Coefficient of Drag vs. Mach Number');
 xlabel('Mach Number');
 ylabel('Coefficient of Drag');


end

