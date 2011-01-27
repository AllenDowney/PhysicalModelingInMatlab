function [ fout ] = tiaxFunction( x, Gprime, H )

% tiaxFunction computes the quaternions by finding the zeros of the
% function of equations 

a = x(1);
b = x(2);
c = x(3);
d = x(4);

fout= [ (a*c - b*d ) - Gprime(1); c*d + a*b - Gprime(2); .5 - (b^2 + c^2) - Gprime(3); H(1)*(b*c + a*d) + H(2)/2 - H(2)*(b^2+d^2) + H(3)*(c*d - a*b) ];

