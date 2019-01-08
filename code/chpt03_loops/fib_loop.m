% Plot the first 10 elements of a Fibonacci sequence

clf
hold on

for n=1:10
    fibonacci2
    plot(n, ans, 'ro')
end
hold off