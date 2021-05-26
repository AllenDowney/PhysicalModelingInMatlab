% Simulate a penny falling from the Empire State Building.

function penny2()
    t = 0;
    X = [381, 0];
    rate_func(t, X)
   
    tspan = [0, 30];
    options = odeset('Events', @event_func);
    [T, M] = ode45(@rate_func, tspan, X, options);
    
    Y = M(:, 1);
    V = M(:, 2);
    
    plot(T, Y)
    xlabel('Time (s)')
    ylabel('Altitude (m)')
    saveas(gcf, '../../book/figs/penny2.eps', 'epsc')
    
    T(end)
    M(end, :)
end

function res = rate_func(t, X)
    % unpack position and velocity
    y = X(1);      
    v = X(2);      
    
    % compute the derivatives
    dydt = v;
    dvdt = acceleration(t, X);

    % pack the derivatives into a column vector
    res = [dydt; dvdt];
end

function res = acceleration(t, X)
    b = 75e-6;                % drag constant in kg/m
    v = X(2);                 % velocity in m/s
    f_d = -sign(v) * b * v^2; % drag force in N

    m = 2.5e-3;               % mass in kg
    a_d = f_d / m;            % drag acceleration in m/s^2

    a_g = -9.8;               % acceleration due to gravity in m/s^2
    res = a_g + a_d;          % total acceleration
end

function [value, isterminal, direction] = event_func(t,X)
    value = X(1);
    isterminal = 1;
    direction = -1;
end