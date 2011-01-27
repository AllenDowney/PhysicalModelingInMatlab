sigma = 10; 
b = 8/3;
r = 28;
dt = 0.01;

X(1) = 1;
Y(1) = 2;
Z(1) = 3;

for i = 1:2000
    X(i+1) = X(i) + sigma * (Y(i) - X(i)) * dt;
    Y(i+1) = Y(i) + (X(i) * (r - Z(i)) - Y(i)) * dt;
    Z(i+1) = Z(i) + (X(i)*Y(i) - b*Z(i)) * dt;
end

plot3(X, Y, Z)
    

