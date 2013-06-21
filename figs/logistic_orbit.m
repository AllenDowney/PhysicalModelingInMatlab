function logistic_orbit
clf
lambda = linspace(-2.5,4.5,1000);
N = length(lambda);
x(1,1:N) = 0.25;
for j = 1:1000
x(j+1,:) = lambda.*x(j,:).*(1-x(j,:));
end
plot(lambda,x(900:1001,:),'k.','MarkerSize',1)
axis([-2.5 4.5 -1 2])
xlabel('\lambda')
ylabel('x(t)')
filename = sprintf('logistic_orbit.png')
print(filename,'-dpng')
end
