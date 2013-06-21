function logistic_period_two_numerical
xi = linspace(-1,2,10000);
for lambda = -2.5:.01:4.5
x = xi;
for j = 1:3
y = lambda.*x.*(1-x);
x = y;
endfor
i = find(abs(y-xi) < 1e-4);
plot(lambda,xi(i),'k*'), hold on
endfor
axis([-2.5 4.5 -1 2])
xlabel('\lambda')
ylabel('x^*')
%filename = sprintf("logistic_fixed_point_numerical.png")
%print(filename,'-dpng')
endfunction
