function [ errs ] = plot_err (psi, noise, func)
% psi is the third euler angle, which is held constant as the others vary.
% noise is the percentage of noise added to G an H
% func is a handle for the function used to convert G, H to rot

% examples:

% test direct.m, which computes euler angles directly
% plot_err(pi, 0.01, @direct)

% test eigenquat.m, which computes the rotation matrix directly,
% then gets a quaternion by eigenvector analysis
% plot_err(pi, 0.01, @eigenquat)

% test newton.m, which estimates the euler parameters by newton's
% method
% plot_err(pi, 0.01, @newton)

% n is the number of values sampled along the theta axis
k = 5;
n = 2^k;

% compute the values of phi and theta
phis = [0 : pi/n : 2*pi];
thetas = [-pi/2 : pi/n : pi/2];

randn('state',0)
for i=1:length(phis)
    phi = phis(i);
    for j=1:length(thetas)
        theta = thetas(j);

        % compute the average error^2 for a set of trials
        ang = [phi theta psi]';
        rms = comp_err (ang, noise, func);
        x(i,j) = phi;
        y(i,j) = theta;
        a(i,j) = rms(1);
        b(i,j) = rms(2);
        c(i,j) = rms(3);
    end
end

% put the error matrices into a cell array
errs{1} = a;
errs{2} = b;
errs{3} = c;

% store the titles for the three graphs
name{1} = '\delta\phi';
name{2} = '\delta\theta';
name{3} = '\delta\psi';

% find the largest element from all three error matrices,
% which is used to set the color scale for all three plots
ma = max(max(a));
mb = max(max(b));
mc = max(max(c));
max_err = max([ma mb mc]);

for i=1:3
    subplot(3,1,i);

    % make a pseudocolor plot
    h = pcolor(x,y,errs{i});
    
    % or make a contour plot (prettier, but slower)
    %h = contour(x,y,errs{i});

    % set the color scale
    caxis([0 max_err]);
    colorbar('EastOutside');

    % set the axes
    axis([0 2*pi -pi/2 pi/2]);

    % draw the title and label the axes
    title(name{i});
    ylabel('\theta');
end

xlabel('\phi');


