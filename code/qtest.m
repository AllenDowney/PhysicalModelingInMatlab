function [ q ] = qtest( angle )

p, t, ps

% Function qtest( angle )
% takes the Euler Angles and converts them to the quaternion
% representation.

q(1) = cos( angle(1)/2 )*cos( angle(2)/2 )*cos( angle(3)/2 ) + sin( angle(1)/2 )*sin( angle(2)/2 )*sin( angle(3)/2 );
q(2) = sin( angle(1)/2 )*cos( angle(2)/2 )*cos( angle(3)/2 ) - cos( angle(1)/2 )*sin( angle(2)/2 )*sin( angle(3)/2 );
q(3) = cos( angle(1)/2 )*sin( angle(2)/2 )*cos( angle(3)/2 ) + sin( angle(1)/2 )*cos( angle(2)/2 )*sin( angle(3)/2 );
q(4) = cos( angle(1)/2 )*cos( angle(2)/2 )*sin( angle(3)/2 ) - sin( angle(1)/2 )*sin( angle(2)/2 )*cos( angle(3)/2 );
