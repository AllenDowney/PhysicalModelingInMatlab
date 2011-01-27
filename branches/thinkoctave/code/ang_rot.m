function [ rot ] = ang_rot (ang)
% given the euler angles in ang, compute the
% rotation matrix, using the Wikipedia page
% http://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles

s1 = sin(ang(1));
s2 = sin(ang(2));
s3 = sin(ang(3));
c1 = cos(ang(1));
c2 = cos(ang(2));
c3 = cos(ang(3));
    
rot = [  c2*c3,   -c1*s3 + s1*s2*c3,     s1*s3 + c1*s2*c3;
         c2*s3,    c1*c3 + s1*s2*s3,    -s1*c3 + c1*s2*s3;
        -s2,       s1*c2,                c1*c2               ];