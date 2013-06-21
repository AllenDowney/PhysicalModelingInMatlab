function logistic_data
lambda = [3.83];
for i = 1:length(lambda)
t(1) = 0;
x(1) = 0.25;
for j = 1:40
x(j+1) = lambda(i).*x(j).*(1-x(j));
t(j+1) = t(j) + 1;
end
plot(t,x,'k*-'),axis([0 40 0 1])
xlabel('t')
ylabel('x')
filename = sprintf('logistic_data%d.png',i)
print(filename,'-dpng')
end
end
