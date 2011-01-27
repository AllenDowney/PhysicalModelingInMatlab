td = sym('td');
pd = sym('pd');

theta = sym('theta'); %primary angle
% t = sym('t');
dthetadt = sym('dthetadt');%diff(theta)
phi = sym('phi');
dphidt = sym('dphidt'); diff(phi)

l1=sym('l1');  %length of the upper lever arm
l2=sym('l2');  %length of th lower lever arm 
l3 = sym('l3'); %throwing arm  
m1=sym('m1');  % mass of the upper lever arm 
m2=sym('m2');  %mass of the lower lever arm 
m3=sym('m3'); %throwing arm


%converting the Y cordinance into theta cordinance 
Y1=-l1*cos(1/2*td^2); 
dY1dt= l1*sin(1/2*td^2)*td;
Y2=-l2*cos(1/2*pd^2) + Y1;
dY2dt= l2*sin(1/2*pd^2)*pd +dY1dt;
Y3=-l3*cos(1/2*td^2);
dY3dt= -l3*sin(1/2*td^2)*td;


%conveting the X cordinace to phi cordinance
X1= l1*sin((1/2)*td^2);
dX1dt= l1*cos((1/2)*td^2)*td;
X2=l2*sin(1/2*pd^2)+X1;
dX2dt= l2*cos(1/2*pd^2)*pd+ dX1dt;
X3=-l3*sin(phi);
dX3dt= -l3*cos(1/2*td^2)*td;

g =-9.8  %gravity

T = 1/2*m1*(dX1dt^2+dY1dt^2) + 1/2*m2*(dX2dt^2+dY2dt^2)+1/2*m3*(dX3dt^2+dY3dt^2);
U = g*m1*Y1 + g*m2*Y2 +g*m3*Y3;

L =  T-U;  %lagrangian 

q = diff(L,td);
w = diff(L,theta)-diff(q,t);
e = diff(L,pd);
r = diff(L,phi)-diff(e,t);