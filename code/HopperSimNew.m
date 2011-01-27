clear

lrest = .0843;
l  = .21;
m  = .09;
dx = l - lrest;
k = 76.2;
g = 9.8;
c = .03;

ry(1) = 0;
vy(1) = sqrt (3 * (k * dx^2) / m);
ay(1) = -9.8;

i = 1;
t(1) = 0;

while ry(i)>=0
   i=i + 1;
   dt=.001; 
   t(i)=i * dt;
   
   ry(i)    =   vy(i-1)  *  dt + ry(i-1);
   vy(i)    =   ay(i-1)  *  dt + vy(i-1);
   ay(i)    =   -g - (c * (vy(i))^2) / m;
   
end

plot (t,ry,'r')
