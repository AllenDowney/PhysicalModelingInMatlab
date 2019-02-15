function baseball()
    P = [0; 1];       % initial position in m
    V = [30; 40];     % initial velocity in m/s
    W = [P; V];       % initial condition
    rate_func(0, W)
    
    tspan = [0 8];
    [T, M] = ode45(@rate_func, tspan, W);
    
    X = M(:, 1);
    Y = M(:, 2);
    
    clf; hold on
    plot(T, X)
    plot(T, Y)
    
    xlabel('Time (s)')
    ylabel('Position (m)')
    legend('X position', 'Y position', 'Location', 'northwest')
    saveas(gcf, '../../book/figs/baseball1.eps', 'epsc')
end

function res = rate_func(t, W)
    P = W(1:2);
    V = W(3:4);

    dPdt = V;
    dVdt = acceleration(t, P, V);

    res = [dPdt; dVdt];
end

function res = acceleration(t, P, V)
    g = 9.8;                       % acceleration of gravity in m/s^2
    gravity = [0; -g];
    res = gravity;
end

