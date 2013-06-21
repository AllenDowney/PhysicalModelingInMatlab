function logistic_cobweb
clf
lambda = [3.83];
for i = 1:length(lambda)
xx = -.5:.01:1.5;
yy = lambda(i).*xx.*(1-xx);
plot(xx,yy,'k'), hold on
plot([-.5 1.5],[-.5 1.5],'k')
t(1) = 0;
x(1) = 0.25;
for j = 1:40
x(j+1) = lambda(i).*x(j).*(1-x(j));
t(j+1) = t(j) + 1;
plot([x(j) x(j+1)],[x(j+1) x(j+1)],'b')
if (j == 1)
plot([x(j) x(j)],[-.5 x(j+1)],'b')
else
plot([x(j) x(j)],[x(j) x(j+1)],'b')
end
end
axis([-.5 1.5 -.5 1.5])
hold off
xlabel('x(t)')
ylabel('x(t+1)')
filename = sprintf('logistic_cobweb%d.png',i)
print(filename,'-dpng')
end
end
