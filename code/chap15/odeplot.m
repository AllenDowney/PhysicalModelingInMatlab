% Run ode45 and plot the locations where it evaluates the rate func.

function odeplot()
    clf; hold on
    total = 0;

    y0 = 1;
    tspan=[0 4];
    options = odeset('Refine', 1);
    [T, Y] = ode45(@rate_func, tspan, y0, options);
    plot(T, Y, '-')

    xlabel('t')
    ylabel('y')
    saveas(gcf, '../../book/figs/odeplot1.eps', 'epsc')

    plot(T, Y, 'bs')
    xlim([0.78 1.22])
    saveas(gcf, '../../book/figs/odeplot2.eps', 'epsc')

    total

    function res = rate_func(t, y)
        dydt = y * sin(t);
        res = dydt;

        plot(t, y, 'ro')
        dt = 0.01;
        ts = [t t+dt];
        ys = [y y+dydt*dt];
        plot(ts, ys, 'r-')

        total = total +1;
    end
end
