% Make a plot comparing results from euler and runge-kutta

function res = runge()
    clf; hold on

    T(1) = 0;
    F(1) = 5;
    dt = 0.1;

    for i=1:40
        r = rate_func(T(i), F(i));
        T(i+1) = T(i) + dt;
        F(i+1) = F(i) + r * dt;
    end
    plot(T, F)
    xlabel('Time (hours)')
    ylabel('Population (billions of cells)')
    saveas(gcf, '../../book/figs/euler.eps', 'epsc')

    F1 = 5;
    [T, F] = ode45(@rate_func, [0, 4], F1);

    plot(T, F, '--')
    legend('euler', 'ode45', 'Location', 'northwest')
    saveas(gcf, '../../book/figs/runge.eps', 'epsc')
end

function res = rate_func(t, y)
   a = 0.2;
   res = a * y;
end
