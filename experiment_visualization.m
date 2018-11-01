%experient_visualization
% load the given data from the file
load experiment1
% create a distance variable from minimum to maximum
x = linspace(min(experiment.alpha_dist),max(experiment.alpha_dist));
% calculate terrain angles
terrain_angle = interp1(experiment.alpha_dist,experiment.alpha_deg,x,'spline');
figure
% plot the calculated terrain angle vs distance
plot(x,terrain_angle,'k','LineWidth',1)
xlabel('Distance (m)')
ylabel('Terrain Angle (deg)')
title('Terrain Angle vs. Distance')
hold on 
% create arrays of the data from the given struct
xfile = experiment.alpha_dist;
yfile = experiment.alpha_deg;
% plot these arrays on the same graph as the previous data 
plot(xfile,yfile,'r*')
hold off
