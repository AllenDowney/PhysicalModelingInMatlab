function [ in, err ] = tiax_test (noise, ang_error)

N = 100;

start = [0 0 0]';
range = [2*pi 0 0]';
stop = start + range;
step =  range / N;

for i=1:N
    ang = start + step * i;
    [ang_err, rms] = comp_err (ang, noise, ang_error);
    in(i,:) = ang;
    err(i,:) = rms;
end


%title = sprintf('\phi = \[%0.2g %0.2g\], ', start(1), stop(1));
phis = sprintf('[%0.2g, %0.2g]', start(1), stop(1));
thetas = sprintf('[%0.2g, %0.2g]', start(2), stop(2));
psis = sprintf('[%0.2g, %0.2g]', start(3), stop(3));
noises = sprintf('%0.3g', noise);
t = ['\phi = ' phis ', \theta = ' thetas ', \psi = ' psis ', noise =' noises];

% aname is an cell array of angle names; aindex indicates which one
% is the xaxis in the plots
aname = ['\phi  '; '\theta'; '\psi  '];
aname = cellstr(aname);
aindex = 1;

x = in(:,aindex);
m = max(max(err));
limits = [start(aindex) stop(aindex) 0 m];

subplot(3,1,1)
h = plot (x, err(:,1), 'r.-');
axis(limits)
title(t)
ylabel(['excess ' aname{1}])

subplot(3,1,2)
h = plot (x, err(:,2), 'g.-');
axis(limits)
ylabel(['excess ' aname{2}])

subplot(3,1,3)
h = plot (x, err(:,3), 'b.-');
axis(limits)
xlabel('0 \leq \phi \leq 2\pi')
ylabel(['excess ' aname{3}])

end

