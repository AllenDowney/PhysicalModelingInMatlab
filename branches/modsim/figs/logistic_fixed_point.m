function logistic_fixed_point
lambda = 3.83;
x = -0.5:.01:1.5;
y = lambda.*x.*(1-x);
plot(x,y,'k'), hold on
plot([-0.5 1.5],[-0.5 1.5],'k')
plot(0,0,'r*')
plot((lambda-1)./lambda,(lambda-1)./lambda,'r*')
axis([-0.5 1.5 -0.5 1.5])
xlabel('x')
ylabel('f(x)')
filename = sprintf('logistic_fixed_point.png')
print(filename,'-dpng')
end
