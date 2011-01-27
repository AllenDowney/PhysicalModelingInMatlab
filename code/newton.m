function [ euler, quat ] = newton ( G, H )

% THIS FUNCTION IS NOT CURRENTLY WORKING.

% Inputs: Two matrices, G accelerometer data and H magentometer data.
% Output: Euler angles and quaternions for rotations.
% Euler output is: [ phi, theta, psi ];
% Quaternion output is: [ q0, w ] where w = { q1, q2, q3 } a vector describing
% the rotating an angle theta about a vector { l,m,n }

g = 9.8;
   
Gprime = G/(2*g);
Hprime = H/norm(H);

x=1/2*ones(4,1);

% implementation of Newton's method to find the components of the
% quaternion
iter = 0;
F = tiaxFunction( x, Gprime, Hprime );
while ( ( norm(F) > 1e-8 ) & ( iter < 50 ) )
    J = tiaxJacobian( x, Gprime, Hprime );
    F = tiaxFunction( x, Gprime, Hprime );
    dx = J\-F;
    x = x + dx;
    iter = iter + 1;
end

% Here's the quaternion
% Normalize the whole quaternion
quat = x./norm( x );

% Normalize the quaternian vector components
quat( 2:4,: )/sqrt( 1 - quat(1)^2 );

% ----- Start Euler Angle conversions ----------------

% We compute the numerator and denominator for the atan2 arguments to 
% make sure we don't send bad information to the function.

phi_n = 2*( quat(1)*quat(2) + quat(3)*quat(4) );
phi_d = 1-2*( quat(2)^2 + quat(3)^2 );

psi_n = 2*( quat(1)*quat(4) + quat(2)*quat(3) );
psi_d = 1-2*( quat(3)^2 + quat(4)^2 );

theta = asin( 2*( quat(1)*quat(3) - quat(4)*quat(2) ) );

if ( (theta ~= pi/2) | (theta ~= -pi/2) )
    phi = atan2( phi_n, phi_d );
    psi = atan2( psi_n, psi_d );
else
    phi = -9999;
    psi = -9999;
end

% Caluculate the three Euler angles, phi, theta, psi
euler(1) = phi;
euler(2) = theta;
euler(3) = psi;

% ------ Done with with Euler Angles -----------------------

% TO DO: ALSO OUTPUT IN FORM 
% [angle rotating around, vector rotating about]
%angle_vector(1) = 2*acos( quat(1) );
%angle_vector(2) = acos( ( quat(2)/( sin( angle_vector(1) ) ) ) );
%angle_vector(3) = acos( ( quat(3)/( sin( angle_vector(1) ) ) ) );
%angle_vector(4) = acos( ( quat(4)/( sin( angle_vector(1) ) ) ) );


function [ fout ] = Function ( x, Gprime, H )

a = x(1);
b = x(2);
c = x(3);
d = x(4);

fout= [ (a*c - b*d ) - Gprime(1); 
        c*d + a*b - Gprime(2);
        .5 - (b^2 + c^2) - Gprime(3); 
        H(1)*(b*c + a*d) + H(2)/2 - H(2)*(b^2+d^2) + H(3)*(c*d - a*b) ];


function [ jout ] = Jacobian( x, G, H )

a = x(1);
b = x(2);
c = x(3);
d = x(4);

lastrow(1,1) = H(1)*d - H(3)*b;
lastrow(1,2) = H(1)*c -2*H(2)*b - H(3)*a;
lastrow(1,3) = H(1)*b + H(3)*d;
lastrow(1,4) = H(1)*a - 2*d*H(2) + c*H(3);

jout = [ c,-d,a,-b; 
         b,a,d,c; 
         0,-2*b, -2*c, 0; 
         lastrow ];

