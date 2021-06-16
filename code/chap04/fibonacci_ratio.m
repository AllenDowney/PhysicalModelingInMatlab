% Plot the ratios of successive elements of a Fibonacci sequence
% Precondition: `n` is a positive integer.

F(1) = 1
F(2) = 1
for i=3:n
    F(i) = F(i-1) + F(i-2)
end

for i=1:n-1
    D(i) = F(i+1) / F(i)
end

plot(D)
