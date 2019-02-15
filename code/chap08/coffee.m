% Use ode45 to predict coffee temperature.

function res = coffee()
    t = 0;
    y0 = 90;
    r = rate_func(t, y0);
    
    [T, Y] = ode45(@rate_func, [0, 60], y0);
    plot(T, Y)
    xlabel('Time (minutes)')
    ylabel('Temperature (C)')
    saveas(gcf, '../../book/figs/coffee.eps', 'epsc')
    
    Y(end)
end

function res = rate_func(t, y)
    k = 0.01;
    e = 20;
    res = -k * (y - e);
end