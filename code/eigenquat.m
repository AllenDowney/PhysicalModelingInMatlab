function [ rot, quat ] = eigenquat(G,H)
% given G accelerometer data and H magnetometer data,
% compute the rotation matrix (body to earth) and the
% quaternion representation of that rotation

grav = 9.8;
    
% change coordinates so that G has norm 1
% and H is orthnormal to G 
G_tilde = -G/norm(G);
H_tilde = H - dot(G_tilde,H)*G_tilde;
H_tilde = H_tilde/norm(H_tilde);

% compute transpose of the rotation matrix 
% rot = [H_tilde; cross(H_tilde,G_tilde); -G_tilde];
rot(:,1) = H_tilde;
rot(:,2) = (cross(H_tilde,G_tilde));
rot(:,3) = (-G_tilde);

% and then transpose it
rot = rot';

% compute the quat. in the form of [angle, vector]
av = rot_av(rot);

% convert from angle vector to get out the quaternion
quat = av_quat(av);

% convert back to Euler angles 
% ang = quat_ang(quat);
