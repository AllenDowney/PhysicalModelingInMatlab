% Plot distance flown versus launch angle for a baseball.

function baseball3()
    P = [0; 1];       % initial position in m
    V = [40; 30];     % initial velocity in m/s
    W = [P; V];       % initial condition
    rate_func(0, W)

    tspan = [0 10];
    options = odeset('Events', @event_func);
    [T, M] = ode45(@rate_func, tspan, W, options);

    T(end)
    M(end, :)

    clf; hold on
    X = M(:, 1);
    Y = M(:, 2);

    plot(X, Y)

    xlabel('Y Position (m)')
    ylabel('X Position (m)')
    saveas(gcf, '../../book/figs/baseball3.eps', 'epsc')

    thetas = linspace(0, pi/2);
    for i = 1:length(thetas)
        ranges(i) = baseball_range(thetas(i));
    end

    clf; hold on
    plot(thetas, ranges)

    [x, fval] = fminsearch(@min_func, pi/4)
    plot([x x], [0, max(ranges)], 'k:')

    xlabel('Launch angle (radian)')
    ylabel('Distance traveled (m)')
    saveas(gcf, '../../book/figs/baseball4.eps', 'epsc')

end

function res = min_func(angle)
    res = -baseball_range(angle);
end

function res = baseball_range(theta)
    P = [0; 1];
    v = 50;
    [vx, vy] = pol2cart(theta, v);

    V = [vx; vy];     % initial velocity in m/s
    W = [P; V];       % initial condition

    tspan = [0 10];
    options = odeset('Events', @event_func);
    [T, M] = ode45(@rate_func, tspan, W, options);

    res = M(end, 1);
end

function res = rate_func(t, W)
    P = W(1:2);
    V = W(3:4);

    dPdt = V;
    dVdt = acceleration(t, P, V);

    res = [dPdt; dVdt];
end

function [value, isterminal, direction] = event_func(t, W)
    value = W(2);
    isterminal = 1;
    direction = -1;
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
