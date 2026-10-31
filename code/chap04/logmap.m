% Compute the first 50 elements of the logistic map

r = 3.9;
clear X
X(1) = 0.5;

for i=1:49
    X(i+1) = r * X(i) * (1 - X(i));
end

plot(X)
