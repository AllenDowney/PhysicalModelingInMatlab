function [ rot ] = quat_rot ( q ) 
% q is a quaternion containing euler parameters
% compute the corresponding rotation matrix, using the
% formulae from the wikipedia page

q0 = q(1);
q1 = q(2);
q2 = q(3);
q3 = q(4);

rot = 2 * [ 0.5 - q2^2 - q3^2, q1*q2 - q0*q3,     q0*q2 + q1*q3 ;
            q1*q2 + q0*q3,     0.5 - q1^2 - q3^2, q2*q3 - q0*q1 ;
            q1*q3 - q0*q2,     q0*q1 + q2*q3,      0.5 - q1^2 - q2^2 ];
