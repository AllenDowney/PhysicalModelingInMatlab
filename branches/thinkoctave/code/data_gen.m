function [ G,H ] = data_gen (ang, noise)
% ang is the actual set of Euler angles that describe the rotation
% from body frame to earth frame.
% noise is the size of the instrument error (no units).

% g is grav, Hh is horizontal and Hv is vertical component of mag field 
% in Earth's frame 
g = 9.8;
Hh = 4E4;
Hv = 2E4;

gnoise = randn(3,1) * noise * g;
hnoise = randn(3,1) * noise * sqrt(Hh^2+Hv^2);

rot = ang_rot(ang);

G = gnoise + rot' * [0, 0, g]';    
H = hnoise + rot' * [Hh 0 Hv]';
