%experient_visualization
% load the given data from the file
load experiment1
% calculate terrain angles
x = linspace(min(experiment.alpha_dist),max(experiment.alpha_dist));
terrain_angle = interp1(experiment.alpha_dist,experiment.alpha_deg,x,'spline');
figure
plot(x,terrain_angle)
xlabel('Distance (m)')
ylabel('Terrain Angle (deg)')
