function result=ladderde(t,x,I,m,g,l);

% This function returns the angular velocity and angular acceleration for a
% ladder falling without friction

% Unpack the input values
theta=x(1);
thetadot=x(2);

numerator=m*g-(m*l/2)*thetadot^2*sin(theta);
denominator=-2*I/(l*cos(theta)) - (m*l/2)*cos(theta);

thetaddot=numerator./denominator;

% Return the results
result=[thetadot;thetaddot];