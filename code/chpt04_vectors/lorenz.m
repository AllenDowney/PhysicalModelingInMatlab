clear all
X(1) = 1;
Y(1) = 2;
Z(1) = 3;

sigma = 10;
b = 8/3;
r = 28;
dt = 0.01;

for i = 1:10000
    X(i+1) = X(i) + sigma * (Y(i) - X(i)) * dt;
    Y(i+1) = Y(i) + (X(i) * (r - Z(i)) - Y(i)) * dt;
    Z(i+1) = Z(i) + (X(i) * Y(i) - b * Z(i)) * dt;
end

comet3(X, Y, Z)