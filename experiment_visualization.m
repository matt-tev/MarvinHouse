%experient_visualization
% load the given data from the file
load experiment1
% calculate terrain angles
x = linspace(min(experiment.alpha_dist),max(experiment.alpha_dist));
terrain_angle = interp1(experiment.alpha_dist,experiment.alpha_deg,x,'spline');
figure
plot(x,terrain_angle,'k','LineWidth',1)
xlabel('Distance (m)')
ylabel('Terrain Angle (deg)')
title('Terrain Angle vs. Distance')
hold on 
xfile = experiment.alpha_dist;
yfile = experiment.alpha_deg;
plot(xfile,yfile,'r*')
hold off
