function [ rot ] = av_rot(av)
% compute the rotation matrix from the angle vector form
% of the quaternion using the matrix on pg 101 of Mukundan

Phi   = av(1);
l     = av(2);
m     = av(3);
n     = av(4);

c = cos(Phi);
s = sin(Phi);
omc = 1 - c; 

rot(1,1) = (l^2)*omc + c;
rot(2,1) = (l*m)*omc + n*s;
rot(3,1) = (n*l)*omc - m*s;

rot(1,2) = (l*m)*omc - n*s;
rot(2,2) = (m^2)*omc + c;
rot(3,2) = (m*n)*omc + l*s;

rot(1,3) = (n*l)*omc + m*s;
rot(2,3) = (m*n)*omc - l*s;
rot(3,3) = (n^2)*omc + c;
