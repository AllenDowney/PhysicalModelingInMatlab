% Simulate the descent of a skydiver who opens the parachute at altitude
% h_open (default 1000 m).  The lowest altitude where they still land at
% less than 6 m/s is about 8 m (the last part of the exercise).

function skydiver(h_open)
    if nargin < 1
        h_open = 1000;        % altitude where the parachute opens, in m
    end
    t = 0;
    X = [4000, 0];
    rate_func(t, X, h_open)

    tspan = [0, 1000];
    options = odeset('Events', @event_func);
    [T, M] = ode45(@(t, X) rate_func(t, X, h_open), tspan, X, options);

    Y = M(:, 1);
    V = M(:, 2);

    plot(T, Y)
    xlabel('Time (s)')
    ylabel('Altitude (m)')

    T(end)
    M(end, :)
end

function res = rate_func(t, X, h_open)
    % unpack position and velocity
    y = X(1);
    v = X(2);

    % compute the derivatives
    dydt = v;
    dvdt = acceleration(t, X, h_open);

    % pack the derivatives into a column vector
    res = [dydt; dvdt];
end

function res = acceleration(t, X, h_open)
    b_free = 0.2;             % drag constant in kg/m
    b_parachute = 29;

    y = X(1);
    if y < h_open
        b = b_parachute;
    else
        b = b_free;
    end

    v = X(2);                 % velocity in m/s
    f_d = -sign(v) * b * v^2; % drag force in N

    m = 75;                   % mass in kg
    a_d = f_d / m;            % drag acceleration in m/s^2

    a_g = -9.8;               % acceleration due to gravity in m/s^2
    res = a_g + a_d;          % total acceleration
end

function [value, isterminal, direction] = event_func(t,X)
    value = X(1);
    isterminal = 1;
    direction = -1;
end
