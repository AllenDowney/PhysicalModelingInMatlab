function [ jout ] = tiaxJacobian( x, G, H )
% Jacobian of the tiaxFunction

a = x(1);
b = x(2);
c = x(3);
d = x(4);

lastrow(1,1) = H(1)*d - H(3)*b;
lastrow(1,2) = H(1)*c -2*H(2)*b - H(3)*a;
lastrow(1,3) = H(1)*b + H(3)*d;
lastrow(1,4) = H(1)*a - 2*d*H(2) + c*H(3);

%jout = [ c,d,a,b; -b,-a,d,c; 0,-2*b, -2*c, 0; H(1)*d - H(3)*b, H(1)*c -2*H(2)*b - H(3)*a, H(1)*b + H(3)*d, H(1)*a - 2*d*H(2) + c*H(3) ];
jout = [ c,-d,a,-b; b,a,d,c; 0,-2*b, -2*c, 0; lastrow ];
