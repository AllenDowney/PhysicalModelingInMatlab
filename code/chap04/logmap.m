% Compute the first 20 elements of the logistic map

clear X
X(1) = 0.5;

for i=1:19
    X(i+1) = r * X(i) * (1 - X(i));
end

plot(X)