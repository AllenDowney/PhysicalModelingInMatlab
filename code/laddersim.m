% Ladder Simulation

close all
clear
x=[pi/2-1 0]                % Set initial conditions: Theta=pi/2-1,thetadot=0
options=odeset;             % Prepare options to use in DE solver
m=10;                       % Masses, lengths, and moment of inertia
l=10;
I=1/12*m*l^2;
g=10;

[t,y]=ode45(@ladderde,[0:0.02:10],x,options,I,m,g,l)

figure;
clf;                  % Prepare to animate
i=1;
for i=1:length(y)
    clf;
    axis([-10 10 -10 10]); 
    axis image;       % Set real aspect ratio for plot 
    hold on;
    h=l/2*sin(y(i,1));
    d=l/2*cos(y(i,1));
    plot([-d,d],[0,h*2],'LineWidth',2);  % Plot the ladder
    plot([-10 10],[0 0],'r');            % Plot the ground
    plot(0,h,'o');                       % Plot the location of the center of mass
    drawnow;                             % Clear the plotting buffer (for better animation)
    hold off;
end
