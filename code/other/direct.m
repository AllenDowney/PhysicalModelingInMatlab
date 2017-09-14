function [ rot, ang ] = direct( G, H )
% Inputs: 3-vectors G accelerometer data and H magnetometer data.
% Output: rotation matrix (body to earth)
% this is the computation documented in the memo from TIAX

gx = G(1);
gy = G(2);
gz = G(3);

hx = H(1);
hy = H(2);
hz = H(3);

phi = atan2(gy, gz);
theta = -atan2(gx, sqrt(gy^2 + gz^2));

cphi = cos(phi);
sphi = sin(phi);
stheta = sin(theta);

y = cphi * hy - sphi * hz;
x = cos(theta) * hx + stheta * sphi * hy + stheta * cphi * hz;
psi = -atan2(y, x);

ang = [phi theta psi]';
rot = ang_rot(ang);