function logistic_fixed_point_analytical
lambda = linspace(-2.5,4.5,100);
x1 = zeros(length(lambda)); 
x2 = (lambda-1)./lambda;
plot(lambda,x1,'k')
plot(lambda,x2,'r')
axis([-2.5 4.5 -1 2])
xlabel('\lambda')
ylabel('x^*')
% filename = sprintf('logistic_fixed_point_analytical.png')
% print(filename,'-dpng')
end
