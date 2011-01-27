function [ ang ] = rot_ang ( rot ) 
% given a rotation matrix, compute the euler angles

% use bottom row of rotation matrix to get theta and phi
% (3,1) term of rotation matrix is -sin(theta)
% (3,2) term of rotation matrix is sin(phi)cos(theta)
% (3,3) term of rotation matrix is cos(phi)cos(theta)
% therefore, tan(phi) = (3,2)/(3,3)
%            tan(theta) = -(3,1)/sqrt((3,2)^2+(3,3)^2)
phi = atan2(rot(3,2), rot(3,3));
theta = atan2(-rot(3,1), sqrt(rot(3,2)^2 + rot(3,3)^2));


% (1,1) term of rotation matrix is cos(theta)cos(psi)
% (2,1) term of rotation matrix is cos(theta)sin(psi)
% therefore, tan(psi) = (2,1)/(1,1)
psi = atan2(rot(2,1), rot(1,1));

ang = [phi theta psi]';
