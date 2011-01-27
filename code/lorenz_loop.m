sigma = 10; 
b = 8/3;
r = 28;
dt = 0.01;

x = 1;
y = 1;
z = 1;

hold on
for i = 1:1000
    lorenz_update
    plot(x,y)
end
   

