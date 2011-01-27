% takes input of roll, pitch and heading angles and outputs accel and mag
% data in body frame with noise
function [ G,H ] = data_gen (ang, noise)
% g is grav, Hh is horizontal and Hv is vertical component of mag field 
% in Earth's frame
g = 9.8;
Hh = 4E4;
Hv = 2E4;

gnoise = noise*g;
hnoise = noise*(Hh^2+Hv^2)^0.5;

%ith col: axis i reading
G = zeros(3, 1);
H = zeros(3, 1);

rot = ang_rot(ang)

G = rot' * [0, 0, -g]';
    
H = rot' * [Hh 0 Hv]';
