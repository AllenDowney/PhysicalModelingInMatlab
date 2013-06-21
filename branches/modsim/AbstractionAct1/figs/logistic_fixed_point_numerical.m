function logistic_fixed_point_numerical
clf
x = linspace(-1,2,1000);
dx = x(2) - x(1);
for lambda = -2.5:.01:4.5
y = lambda.*x.*(1-x);
i = find(abs(y-x) < 1e-3);
plot(lambda,x(i),'k*','MarkerSize',4), hold on
end
axis([-2.5 4.5 -1 2])
xlabel('\lambda')
ylabel('x^*')
filename = sprintf('logistic_fixed_point_numerical.png')
print(filename,'-dpng')
end