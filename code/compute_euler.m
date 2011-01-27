function [ phi, theta, psi ] = compute_euler( rotation, trans ) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function computes the euler angles from the known
% rotation matrix found by the quaternions 
% the original rotation matrix to which we're comparing: rotation
% and if we're working with the original matrix (trans = 0) or not (=1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ( trans == 0 )
   r_mat = rotation;
else
   r_mat = rotation';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use bottom row of rotation matrix to get theta and phi
% (3,1) term of rotation matrix is -sin(theta)
% (3,2) term of rotation matrix is sin(phi)cos(theta)
% (3,3) term of rotation matrix is cos(phi)cos(theta)
% therefore, tan(phi) = (3,2)/(3,3)
%            tan(theta) = -(3,1)/sqrt((3,2)^2+(3,3)^2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phi = atan2(r_mat(3,2), r_mat(3,3));
theta = atan2(-r_mat(3,1), sqrt(r_mat(3,2)^2 + r_mat(3,3)^2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (1,1) term of rotation matrix is cos(theta)cos(psi)
% (2,1) term of rotation matrix is cos(theta)sin(psi)
% therefore, tan(psi) = (2,1)/(1,1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psi = atan2(r_mat(2,1), r_mat(1,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dealing with singularity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test_theta = ( abs(theta) > pi/2 - 1e-4 ) & ( abs(theta) < pi/2 + 1e-4 );
if (test_theta)
   phi = -999;
   psi = -999;
end
