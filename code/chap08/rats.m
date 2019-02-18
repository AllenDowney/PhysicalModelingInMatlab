% Use ode45 to predict the rat population.

function res = rats()
    t = 365/2;
    y = 1000;
    res = rate_func(t, y);
    
    %ts = linspace(0, 365);
    %ys = rate_func(ts, 2000);
    %plot(ts, ys);
    
    [T, Y] = ode45(@rate_func, [0, 365], 1000);
    plot(T, Y)
    xlabel('Time (days)')
    ylabel('Population (rats)')
    saveas(gcf, '../../book/figs/rats.eps', 'epsc')
    
    Y(end)
end

function res = rate_func(t, y)
    a = 0.002;
    omega = 2*pi / 365;
    res = a * y * (1 - cos(omega * t));
end