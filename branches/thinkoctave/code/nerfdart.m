clear
clc
clf
Cd=1.3; %it ranges between .2 and 2, and the book gave this for a skydiver

rhoair=1.20; %in kg/m^3

r=.01; %radius of dart=.008
A=pi*r^2; %area for the alpha and beta

vo=10; %initial velocity
theta=(pi/4) %initial launch angle
vx=vo*cos(theta) %initial velocity in the x direction
vy=vo*sin(theta) %initial velocity in the y direction

m=.002; %mass of dart in grams

g=-9.8; %acceleration due to gravity in meters/second^2

x=0; %initial x position
y=0; %initial position we're not sure about launching from zero, we'll figure it out

xc=(vx^2)/g;
yc=(vy^2)/g;
tcx=vx/g;
tcy=vy/g;

SX(1)=x/xc;
SY(1)=y/yc;
VX(1)=vx*tcx/xc;
VY(1)=vy*tcy/yc;

dT=.01
for n=1:200
    alpha=(.5*Cd*rhoair*A*(vy^2))/(m*g); 

    beta=(.5*Cd*rhoair*A*(vx^2))/(m); %notice no g because of no g in the xdirection

    AX(n)=-beta*VX(n)*sqrt(VX(n).^2+VY(n).^2);
    AY(n)=-1-alpha*VY(n)*sqrt(VX(n).^2+VY(n).^2);
   
    VX(n+1)=VX(n)+AX(n).*dT;
    VY(n+1)=VY(n)+AY(n).*dT;5
    
    SX(n+1)=SX(n)+VY(n).*dT;
    SY(n+1)=SY(n)+VX(n).*dT;
end
hold on
plot(SY,SX) %this has results that aren't in real world dimensions







