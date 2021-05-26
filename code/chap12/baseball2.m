% Simulate the flight of a baseball with drag.

function baseball2()
    P = [0; 1];       % initial position in m
    V = [40; 30];     % initial velocity in m/s
    W = [P; V];       % initial condition
    rate_func(0, W)

    tspan = [0 6];
    [T, M] = ode45(@rate_func, tspan, W);

    X = M(:, 1);
    Y = M(:, 2);

    clf; hold on
    plot(T, X)
    plot(T, Y)

    xlabel('Time (s)')
    ylabel('Position (m)')
    legend('X position', 'Y position', 'Location', 'northwest')
    saveas(gcf, '../../book/figs/baseball2.eps', 'epsc')
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
    a_gravity = [0; -g];

    m = 0.145;                     % mass in kilograms
    a_drag = drag_force(V) / m;
    res = a_gravity + a_drag;
end

function res = drag_force(V)
    C_d = 0.3;      % dimensionless
    rho = 1.3;      % kg / m^3
    A = 0.0042;     % m^2
    v = norm(V);    % m/s

    res = - 1/2 * C_d * rho * A * v * V;
end

