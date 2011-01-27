function [ quat ] = ang_quat ( ang ) 
% ang is a set of euler angles.
% compute the corresponding quaternion, using the
% formulae from the wikipedia page
% http://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles

a1 = ang(1);
a2 = ang(2);
a3 = ang(3);

c1 = cos(a1/2);
c2 = cos(a2/2);
c3 = cos(a3/2);

s1 = sin(a1/2);
s2 = sin(a2/2);
s3 = sin(a3/2);

q0 = c1*c2*c3 + s1*s2*s3;
q1 = s1*c2*c3 - c1*s2*s3;
q2 = c1*s2*c3 + s1*c2*s3;
q3 = c1*c2*s3 - s1*s2*c3;

quat = [q0 q1 q2 q3]';

